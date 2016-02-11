# How to use.

To use the scripts with the *.sh extension you need to look what functions they use and look into the sourced file in each script
and you'll see what functions are in use, the functions are declared in *./default/include/* folder.

For the script *mysqlbck.py* you'll need to install a package with pip.

  # pip install MySQL-python
  
  After install you can test it...
  
  Acess python command line

```bash
   # python
```

While in the python command line write down the following
     
```python
     >>> import MySQLdb
     >>> host = 'hostname'
     >>> port = 'port_num'
     >>> user = 'username'
     >>> pwd = 'your_password'
     >>> connection=MySQLdb.connect(host,port,user,password,db)
  ```
  If all goes well then you can use the script.
