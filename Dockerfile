FROM docker

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 744 /docker-entrypoint.sh

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
