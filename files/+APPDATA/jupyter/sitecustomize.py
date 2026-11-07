import sys

if sys.platform == "win32":
    try:
        from jupyter_server.serverapp import ServerApp
        ServerApp._init_asyncio_patch = lambda self: None
    except Exception:
        pass
