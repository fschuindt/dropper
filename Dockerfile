FROM erlang:20.2.3-alpine

RUN apk add --no-cache bash openssh && \
    mkdir -p /var/run/sshd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "sshd: ALL" > /etc/hosts.allow && \
    ssh-keygen -A

COPY .ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN chmod 700 /root/.ssh/ && \
    chmod 600 /root/.ssh/authorized_keys

CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 2222
