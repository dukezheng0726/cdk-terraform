      #!/bin/bash
      echo "Running custom user data script"
      amazon-linux-extras enable php7.4
      sudo yum install -y php php-cli php-fpm php-mysqlnd php-xml php-mbstring php-curl php-zip
      yum install httpd php-mysql -y
      yum update -y
      cd /var/www/html
      echo "healthy" > healthy.html
      wget https://wordpress.org/wordpress-6.7.1.tar.gz
      tar -xzf wordpress-6.7.1.tar.gz
      cp -r wordpress/* /var/www/html/
      rm -rf wordpress
      rm -rf wordpress-6.7.1.tar.gz
      chmod -R 755 wp-content
      chown -R apache:apache wp-content
      mv wp-config-sample.php wp-config.php
      sed -i 's/database_name_here/${dbname}/g' wp-config.php
      sed -i 's/username_here/${username}/g' wp-config.php
      sed -i 's/password_here/#{password}/g' wp-config.php
      sed -i 's/localhost/${db_endpoint}/g' wp-config.php
      service httpd start
      chkconfig httpd on