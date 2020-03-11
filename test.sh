cat <<ActiveMQSERVICE | sudo tee testme.resultat
[Unit]
Description=Apache ActiveMQ
After=network.target

[Service]
Type=forking

User=activemq
Group=activemq

ExecStart=/opt/activemq/bin/activemq start
ExecStop=/opt/activemq/bin/activemq stop

[Install]
ActiveMQSERVICE