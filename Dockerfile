FROM alpine:3.20.3

RUN apk update \
    && apk add --no-cache \
    bash=5.2.26-r0 \
    openssh=9.7_p1-r4 \
    sshpass=1.10-r0 \
    python3=3.12.8-r1 \
    py3-pip=24.0-r2 \
    && python3 -m venv /venv \
    && . /venv/bin/activate \
    && pip install --upgrade pip \
    && pip install ansible==11.0.0 passlib==1.7.4

ENV PATH="/venv/bin:$PATH"

COPY ./ansible.cfg /etc/ansible/ansible.cfg
COPY ./requirements.yml /tmp/requirements.yml

RUN ansible-galaxy collection install -r /tmp/requirements.yml

SHELL ["/bin/bash", "-c"]

CMD ["bash"]