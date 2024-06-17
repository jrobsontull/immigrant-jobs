## Set up

1. Install deps

```
cd immigrant-jobs
yarn
```

2. Add .env file using .env.example as an example

3. Set up DB

```
yarn prisma generate
yarn prisma migrate dev
```

4. Run python script to populate DB

```
cd misc
python3 populate.py 2023_qt.csv
```

5. Verify DB populated

```
yarn prisma studio
```
