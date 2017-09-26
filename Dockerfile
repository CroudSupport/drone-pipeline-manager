FROM alpine/git
ADD set-vars.sh /bin/

RUN chmod +x /bin/set-vars.sh

ENV DRONE_BUILD_EVENT push

ENTRYPOINT /bin/set-vars.sh