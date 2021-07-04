FROM cytopia/ansible:2.10-tools

RUN set -eux \
	&& pip3 install --no-cache-dir \
    google-auth

WORKDIR /home/ansible
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
