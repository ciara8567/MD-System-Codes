%Email address: This preference sets your email address that will appear on the message.
    %setpref('Internet','E_mail','clugo8567@gmail.com');
%SMTP server: This preference sets your outgoing SMTP server address, which can be almost any email server that supports the Post Office Protocol (POP) or the Internet Message Access Protocol (IMAP).

    %setpref('Internet','SMTP_Server','gmail.com');

%Find your outgoing SMTP server address in your email account settings in your email client application. 
%You can also contact your system administrator for the information.
%Once you have properly configured MATLAB, you can use the sendmail function. The sendmail function requires at least two 
%arguments: the recipient's email address and the email subject.
    %sendmail('ciara8567@email.arizona.edu','Hello From MATLAB!');

%You can supply multiple email addresses using a cell array of character vectors.
    %sendmail({'recipient@someserver.com','recipient2@someserver.com'}, 'Hello From MATLAB!');

%You can specify a message body.
    %sendmail('recipient@someserver.com','Hello From MATLAB!', 'Thanks for using sendmail.');

%You can attach files to an email.
    %sendmail('recipient@someserver.com','Hello from MATLAB!', 'Thanks for using sendmail.','C:\yourFileSystem\message.txt');
%You cannot attach a file without including a message. However, the message can be empty.
%You can attach multiple files to an email.
    %sendmail('recipient@someserver.com','Hello from MATLAB!', ...
    %    'Thanks for using sendmail.',{'C:\yourFileSystem\message.txt', ...
    %    'C:\yourFileSystem\message2.txt'});
%telnet smtp.gmail.com 25
%setpref('Internet','SMTP_Server','smtp.gmail.com');
%%setpref('Internet','E_mail','clugo8567@gmail.com');
%sendmail('biggbrowneyedgirl@gmail.com','Test email', 'Test');

%username='clugo8567@gmail.com';
%pass='XXXXX';
%telnet smtp.live.com 25
%port='587';   % hotmail
%props = java.lang.System.getProperties;
%props.setProperty('mail.smtp.starttls.enable', 'true' );
%props.setProperty('mail.smtp.auth','true');
%props.setProperty('mail.smtp.socketFactory.port',port);
%setpref('Internet','SMTP_Server','smtp.live.com');
%setpref('Internet','E_mail',username);
%setpref('Internet','SMTP_Username',username);
%setpref('Internet','SMTP_Password',pass);
%sendmail(username,'Available');

% Define these variables appropriately:
mail = 'hickenbottomlab@gmail.com'; %Your Yahoo email address
psswd = 'membraneDist2K18';  %Your Yahoo password
host = 'smtp.gmail.com';
port  = '465';
setpref('Internet','SMTP_Server', host);
setpref( 'Internet','E_mail', mail );
setpref( 'Internet', 'SMTP_Server', host );
setpref( 'Internet', 'SMTP_Username', mail );
setpref( 'Internet', 'SMTP_Password', psswd );
props = java.lang.System.getProperties;
props.setProperty( 'mail.smtp.user', mail );
props.setProperty( 'mail.smtp.host', host );
props.setProperty( 'mail.smtp.port', port );
props.setProperty( 'mail.smtp.starttls.enable', 'true' );
props.setProperty( 'mail.smtp.debug', 'true' );
props.setProperty( 'mail.smtp.auth', 'true' );
props.setProperty( 'mail.smtp.socketFactory.port', port );
props.setProperty( 'mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory' );
props.setProperty( 'mail.smtp.socketFactory.fallback', 'false' );
% Send the email.  Note that the first input is the address you are sending the email to
sendmail('ciara8567@email.arizona.edu', 'Test from MATLAB','Hello! This is a test from MATLAB!')


