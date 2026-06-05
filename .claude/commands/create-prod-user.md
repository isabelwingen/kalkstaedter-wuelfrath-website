Create a new admin user in the kalk-website production environment.

The email address to use: $ARGUMENTS

Steps:
1. SSH into the production server and find the running kalk-website container:
   ```
   ssh root@49.13.13.196 "docker ps --format '{{.Names}}' | grep -v coolify | grep kalk-website | head -1"
   ```
   If no container name contains "kalk-website", run `docker ps --format '{{.Names}}' | grep -v coolify` to find the right container — it's the one that is NOT a Coolify management container.

2. Run the following Rails one-liner in that container to create the user and send the password reset email:
   ```bash
   ssh root@49.13.13.196 "docker exec <container-name> bin/rails runner \"
     email = '$ARGUMENTS'
     password = SecureRandom.hex(16)
     user = User.create!(email_address: email, password: password, password_confirmation: password)
     PasswordMailer.reset(user).deliver_now
     puts 'User created: ' + user.email_address
   \""
   ```
   Replace `<container-name>` with the name found in step 1.
   Use `deliver_now` (not `deliver_later`) so delivery happens synchronously and errors are visible immediately.

3. Report back:
   - Whether the user was created successfully
   - Whether the mail was sent
   - Any errors that occurred