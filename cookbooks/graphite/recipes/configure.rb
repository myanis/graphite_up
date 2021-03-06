cookbook_file '/etc/apache2/sites-available/graphite' do
  source 'graphite'
end

execute 'create graphite.wsgi' do
  command 'cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi'
  not_if 'test -f /opt/graphite/conf/graphite.wsgi'
end

execute 'create carbon.conf' do
  command 'cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf'
  not_if 'test -f /opt/graphite/conf/carbon.conf'
end

cookbook_file '/opt/graphite/conf/storage-schemas.conf' do
  source 'storage-schemas.conf'
end

execute 'setup Graphite django DB' do
  command 'python manage.py syncdb --noinput'
  cwd '/opt/graphite/webapp/graphite'
end

execute 'set graphite/storage directory perms' do
  command 'chown -R www-data:www-data /opt/graphite/storage/'
end

execute 'use graphite vhost instead of default' do
  command '/usr/sbin/a2dissite default && /usr/sbin/a2ensite graphite'
end
