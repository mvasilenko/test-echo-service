import asyncio
import os
from datetime import datetime
import time
import json
import re

DEBUG = True

def parse_message(message):
    # construct response
    data = {}
    data['timestamp'] = int(time.time())
    data['hostname'] = hostname
    data['container'] = container_name
    # try to find [dd-mm-yyyy HH:MM] MESSAGE BODY
    pattern = re.compile(r'^\[(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2})] (.+)')
    match = pattern.match(message)
    if match:
        # if found, construct epoch
        time_tuple = datetime.strptime(match.group(3) + "-" + match.group(2) + "-" + match.group(1) + " " +
                                       match.group(4) + ":" + match.group(5) , '%Y-%m-%d %H:%M')
        data['timestamp'] = int((time_tuple - datetime(1970, 1, 1)).total_seconds())
        data['message'] = match.group(6)
    else:
        # not found, current epoch
        data['message'] = "Wrong message received, excepting [DD/MM/YYYY HH:MM] MESSAGE BODY"
    return data

async def handle_echo(reader, writer):
    data = await reader.read(100)
    try:
        message = data.decode()
    except UnicodeDecodeError:
        message = "Non-string received"

    addr = writer.get_extra_info('peername')
    # ignore CloudWatch health checks (empty strings)
    if message != '':
        if DEBUG: print("Received %r from %r" % (message, addr), flush=True)

        out_message = json.dumps(parse_message(message))

        if DEBUG: print("Send: %r" % out_message, flush=True)
        writer.write(out_message.encode())
        await writer.drain()

    writer.close()


# read env vars
port = os.getenv('PORT', 8000)
hostname = os.getenv('HOSTNAME', 'hostname-default')
container_name = os.getenv('CONTAINERNAME', 'container_name-default')
# run asyncio event loop
loop = asyncio.get_event_loop()
coro = asyncio.start_server(handle_echo, '0.0.0.0', port, loop=loop)
server = loop.run_until_complete(coro)

# Serve requests until Ctrl+C is pressed
print('Serving on {}'.format(server.sockets[0].getsockname()), flush=True)
try:
    loop.run_forever()
except KeyboardInterrupt:
    pass

# Close the server
server.close()
loop.run_until_complete(server.wait_closed())
loop.close()
