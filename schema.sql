-- postgresql 9.1 schema for enron messages
drop table if exists messages cascade;
create table messages(
  id varchar(255) primary key not null,
  sent timestamp with time zone not null,
  sender varchar(255) not null,
  subject varchar(255) null
  -- body text not null
);


drop table if exists conversations cascade;
create table conversations(
  message_id varchar(255) references messages(id) not null,
  email varchar(255) not null,
  primary key(message_id, email)
);

