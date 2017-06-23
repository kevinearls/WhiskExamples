# A script for starting OpenWhisk on Fedora 25.  This should be run for the top level directory of OpenWhisk source.
set -x

# docker config  -- this section is only needed for the initial installation
#s sh -c 'cat > /etc/docker/daemon.json <<EOF
#{
#  "hosts": ["tcp://172.17.0.1:4243", "unix:///var/run/docker.sock"]
#}
#EOF'
#s systemctl restart docker
export DOCKER_HOST="tcp://172.17.0.1:4243"

# Run this command if you need to rebuild the docker images 
#./gradlew distDocker

# deploy it
sudo setenforce 0 
sudo iptables -F 
docker kill `d ps -aq` || true
docker rm -f `d ps -aq` || true
docker network rm `d network ls -q` || true
cd ${HOME}/sources/apache/openwhisk/ansible 
#s chown kearls:kearls -R .. && \  Once again, only needed the first time, if at all
ansible-playbook -i environments/local openwhisk.yml -e mode=clean --ask-sudo-pass 
ansible-playbook -i environments/local prereq.yml -e mode=clean --ask-sudo-pass 
ansible-playbook -i environments/local setup.yml 
ansible-playbook -i environments/local prereq.yml --ask-sudo-pass 
ansible-playbook -i environments/local couchdb.yml 
ansible-playbook -i environments/local initdb.yml
ansible-playbook -i environments/local wipe.yml 
ansible-playbook -i environments/local openwhisk.yml --ask-sudo-pass 
ansible-playbook -i environments/local postdeploy.yml

# cli config
cd ..
wsk property set --apihost http://172.17.0.1:10001
wsk property set --auth `cat ansible/files/auth.guest`
wsk action invoke /whisk.system/utils/echo -p message hello --result
