import logging

logger = logging.getLogger(__name__)

class RequestLoggingMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # This code is executed for each request before
        # the view (and other middleware) are called.
        logger.debug("\n\n****** PRINTING HTTP REQUEST ******\n\n")
        logger.debug("Method: %s", request.method)
        logger.debug("Path: %s", request.path)
        try:
            logger.debug("Body: %s", request.body.decode('utf-8'))
        except:
            logger.debug("Could not decode body")
        logger.debug("User: %s", request.user)
        logger.debug("Headers: %s", dict(request.headers))

        response = self.get_response(request)

        # This code is executed for each request/response after
        # the view is called.

        return response