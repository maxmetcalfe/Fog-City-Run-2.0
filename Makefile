
db-remote:
	echo "Capturing Heroku db..."
	heroku pg:backups:capture
	heroku pg:backups:download
	pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(USERNAME) -d $(DB) latest.dump
	rm latest.dump
	echo "Done."

lint:
	rake eslint:run_all
