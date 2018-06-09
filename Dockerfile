FROM docker

# Environment Variables
ENV CONTAINER_NAME="" \
    FORCE_UPDATE="true"

# Docker entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 744 /docker-entrypoint.sh

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
