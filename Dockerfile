FROM debian

ENV NOTVISIBLE "in users profile"

RUN apt-get update && \
    apt-get install -y ssh openssh-server supervisor && \
    mkdir /run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    echo 'root:password' | chpasswd

ADD configs/supervisor/conf.d/* /etc/supervisor/conf.d/

CMD ["supervisord", "-nc", "/etc/supervisor/supervisord.conf"]
