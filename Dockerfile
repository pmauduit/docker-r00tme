FROM debian:jessie

MAINTAINER pmauduit@beneth.fr

# Install and configure openssh-server
RUN apt-get update                               \
&& apt-get install -y openssh-server rsync wget  \
  curl apt-transport-https sudo

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list


RUN apt-get update && apt-get install -y docker-engine \
  && rm -rf /var/lib/apt/lists/*

# Configure ssh user
RUN useradd -r -d /home/sftp sftp \
&& mkdir -p /home/sftp/.ssh \
&& chown -R sftp.sftp /home/sftp

RUN addgroup sftp sudo
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN curl https://github.com/pmauduit.keys > /home/sftp/.ssh/authorized_keys \
  && chmod 700 /home/sftp/.ssh \
  && chmod 600 /home/sftp/.ssh/authorized_keys \
  && chown sftp:sftp /home/sftp/.ssh/authorized_keys
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd

# Define VOLUMES
VOLUME [ "/var/run/docker.sock" ]

# Configure entrypoint and command
COPY docker-entrypoint.sh /
COPY docker-entrypoint.d /docker-entrypoint.d

# MOTD
COPY motd /etc/motd

ENTRYPOINT ["/docker-entrypoint.sh", "/usr/sbin/sshd", "-D"]
