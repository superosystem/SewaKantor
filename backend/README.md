# Sewa Kantor Web Services

## Features

## How it works

## API

**AUTHENTICATIONS**
<details>
<summary>REGISTER</summary>

- REQUEST | `POST` `BASE_URL/register`
```json
{
  "full_name": "jhondoe",
  "gender": "male",
  "email": "jhondoe@gmail.com",
  "password": "secretpwd123",
  "confirmation_password": "secretpwd123"
}
```

- RESPONSE | `SUCCESS`
```json
{
  "id": 1,
  "full_name": "jhondoe",
  "gender": "male",
  "email": "jhondoe@gmail.com",
  "created_at": "<dateTime>",
  "updated_at": "<dateTime>",
  "deleted_at": "<dateTime>"
}
```

- RESPONSE | `FAILED`
```json
{
  "message": "failed"
}
```

</details>

<details>
<summary>LOGIN</summary>

- REQUEST | `POST` `BASE_URL/login`
```json
{
    "email": "jhondoe@gmail.com",
    "password": "secretpwd123"
}
```
- RESPONSE | `SUCCESS`
```json
{
    "token": "<KEY>"
}
```
- RESPONSE | `FAILED`
```json
{
  "message": "failed"
}
```

</details>

**ADMINS**

<details>
<summary>CREATE ADMIN</summary>

- REQUEST | `POST` `BASE_URL/admin` | `AUTH` `{BearerToken}`
```json
{
    "email": "jhondoe@gmail.com",
    "password": "secretpwd123"
}
```
- RESPONSE | `SUCCESS`
```json
{
    "token": "<KEY>"
}
```
- RESPONSE | `FAILED`
```json
{
  "message": "failed"
}
```

3. OFFICES
4. TRANSACTIONS
5. 
