FROM java:6-jdk

ENV LDAP_PORT 389
ENV ADMIN_CONNECTOR_PORT 4444
ENV PASSWORD admin
ENV BASE_DN o=isp
ENV LDIF_FILE sample.ldif

WORKDIR /opt
COPY files/OpenDJ-2.6.0.zip /opt/
RUN unzip OpenDJ-2.6.0.zip && rm -f OpenDJ-2.6.0.zip

RUN /opt/opendj/setup \
          --cli \
          --baseDN ${BASE_DN} \
          --ldapPort ${LDAP_PORT} \
          --adminConnectorPort ${ADMIN_CONNECTOR_PORT} \
          --rootUserDN cn=Directory\ Manager \
          --rootUserPassword ${PASSWORD} \
          --no-prompt \
          --noPropertiesFile \
          --acceptLicense

COPY files/99-custom.ldif /opt/opendj/config/schema/99-custom.ldif

COPY files/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]

EXPOSE ${LDAP_PORT}
EXPOSE ${ADMIN_CONNECTOR_PORT}

WORKDIR /opt/opendj
