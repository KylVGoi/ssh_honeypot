FROM debian:bullseye

# Installer OpenSSH et sudo
RUN apt-get update && \
    apt-get install -y openssh-server sudo bsdutils && \
    rm -rf /var/lib/apt/lists/*

# Créer l'utilisateur honeypot
RUN useradd -m -s /bin/bash support && \
    echo "support:#06Babyluv" | chpasswd && \
    usermod -aG sudo support

# Préparer SSH
RUN mkdir /var/run/sshd && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config && \
    echo "SyslogFacility AUTH" >> /etc/ssh/sshd_config

# Configuration bash pour journaliser les commandes
RUN echo "export HISTFILE=/home/support/.bash_history" >> /home/support/.bashrc && \
    echo "export HISTSIZE=10000" >> /home/support/.bashrc && \
    echo "export HISTFILESIZE=20000" >> /home/support/.bashrc && \
    echo "export PROMPT_COMMAND='history -a; history 1 >> /home/support/.command_log'" >> /home/support/.bashrc && \
    touch /home/support/.bash_history /home/support/.command_log && \
    chown support:support /home/support/.bash_history /home/support/.command_log

# Copier l'entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]

