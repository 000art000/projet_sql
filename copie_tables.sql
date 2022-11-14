
\COPY country FROM 'CSV/country.csv' WITH csv header;
\COPY port FROM 'CSV/port.csv' WITH csv header;
\COPY ship FROM 'CSV/ship.csv' WITH csv header;
\COPY relation_diplomatique FROM 'CSV/relation_diplomatique.csv' WITH csv header;
\COPY categorie_produit FROM 'CSV/categorie_produit.csv' WITH csv header;
\COPY produit FROM 'CSV/produit.csv' WITH csv header;
\COPY voyage FROM 'CSV/voyage.csv' WITH csv header;
\COPY voyage_termine FROM 'CSV/voyage_termine.csv' WITH csv header;
\COPY quantite_depart FROM 'CSV/quantite_depart.csv' WITH csv header;
\COPY debarquement FROM 'CSV/debarquement.csv' WITH csv header;
\COPY acheter FROM 'CSV/acheter.csv' WITH csv header;
\COPY vendre FROM 'CSV/vendre.csv' WITH csv header;
\COPY capture FROM 'CSV/capture.csv' WITH csv header;