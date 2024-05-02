FROM salesforce/cli:latest-full

LABEL org.opencontainers.image.source = "https://github.com/muselab-d2x/d2x"

# Install Python
RUN apt-get update; \
  apt-get upgrade -y; \
  apt-get install -y python3-pip

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg; \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null; \
  apt-get install -y gh

# Install CumulusCI
RUN pip install --no-cache-dir --upgrade pip pip-tools \
  pip --no-cache-dir install git+https://github.com/muselab-d2x/d2x-cli@main cookiecutter

# Copy devhub auth script and make it executable
COPY d2x_job_run.sh /usr/local/bin/d2x_job_run.sh
COPY devhub.sh /usr/local/bin/devhub.sh
RUN chmod +x /usr/local/bddin/d2x_job_run.sh
RUN chmod +x /usr/local/bin/devhub.sh

# Create d2x user
RUN useradd -r -m -s /bin/bash -c "D2X User" d2x

# Setup PATH
RUN echo 'export PATH=~/.local/bin:$PATH' >> /root/.bashrc;\
  echo 'export PATH=~/.local/bin:$PATH' >> /home/d2x/.bashrc;\
  echo '/usr/local/bin/devhub.sh' >> /root/.bashrc;\
  echo '/usr/local/bin/devhub.sh' >> /home/d2x/.bashrc

USER d2x
CMD ["bash"]
