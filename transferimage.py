import paramiko

def scp_file(source_path, destination_path, hostname, username, password):
    try:
        transport = paramiko.Transport((hostname, 22))
        transport.connect(username=username, password=password)
        sftp = paramiko.SFTPClient.from_transport(transport)
        
        sftp.put(source_path, destination_path)
        
        sftp.close()
        transport.close()
        print("File transferred successfully!")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

# Replace these with your values
source_path = '/path/to/source/file.txt'
destination_path = '/path/to/destination/file.txt'
hostname = 'destination_ip'
username = 'your_username'
password = 'your_password'

scp_file(source_path, destination_path, hostname, username, password)
