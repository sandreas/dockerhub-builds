FROM linuxserver/beets:1.6.0 as beets

ENV BEETS_USERNAME=shared

# Create a group and user
RUN adduser -D -G users $BEETS_USERNAME

# Switch to the new user
USER $BEETS_USERNAME

CMD ["help"]
ENTRYPOINT ["beet"]

