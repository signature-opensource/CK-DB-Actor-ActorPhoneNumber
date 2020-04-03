--[beginscript]

declare @CountryCallingCode table
(
    PhoneNumberPrefix varchar( 4 ) collate Latin1_General_100_CI_AS,
    Iso3166Name varchar( 2 ) collate Latin1_General_100_CI_AS,
    RegionPrefixId int not null,

    primary key( PhoneNumberPrefix, Iso3166Name )
);

insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1', 'CA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1', 'PR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1', 'US', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1242', 'BS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1246', 'BB', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1264', 'AI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1268', 'AG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1284', 'VG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1340', 'VI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1345', 'KY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1441', 'BM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1473', 'GD', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1649', 'TC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1664', 'MS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1670', 'MP', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1671', 'GU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1684', 'AS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1721', 'SX', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1758', 'LC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1767', 'DM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1784', 'VC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1809', 'DO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1829', 'DO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1849', 'DO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1868', 'TT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1869', 'KN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '1876', 'JM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '20', 'EG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '211', 'SS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '212', 'MA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '212', 'EH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '213', 'DZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '216', 'TN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '218', 'LY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '220', 'GM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '221', 'SN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '222', 'MR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '223', 'ML', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '224', 'GN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '225', 'CI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '226', 'BF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '227', 'NE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '228', 'TG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '229', 'BJ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '230', 'MU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '231', 'LR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '232', 'SL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '233', 'GH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '234', 'NG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '235', 'TD', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '236', 'CF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '237', 'CM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '238', 'CV', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '239', 'ST', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '240', 'GQ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '241', 'GA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '242', 'CG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '243', 'CD', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '244', 'AO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '245', 'GW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '246', 'IO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '248', 'SC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '249', 'SD', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '250', 'RW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '251', 'ET', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '252', 'SO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '253', 'DJ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '254', 'KE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '255', 'TZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '256', 'UG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '257', 'BI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '258', 'MZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '260', 'ZM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '261', 'MG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '262', 'TF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '262', 'YT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '262', 'RE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '263', 'ZW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '264', 'NA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '265', 'MW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '266', 'LS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '267', 'BW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '268', 'SZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '269', 'KM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '27', 'ZA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '290', 'SH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '291', 'ER', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '297', 'AW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '298', 'FO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '299', 'GL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '30', 'GR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '31', 'NL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '32', 'BE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '33', 'FR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '34', 'ES', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '350', 'GI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '351', 'PT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '352', 'LU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '353', 'IE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '354', 'IS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '355', 'AL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '356', 'MT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '357', 'CY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '358', 'FI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '358', 'AX', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '359', 'BG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '36', 'HU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '370', 'LT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '371', 'LV', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '372', 'EE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '373', 'MD', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '374', 'AM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '375', 'BY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '376', 'AD', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '377', 'MC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '378', 'SM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '380', 'UA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '381', 'RS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '382', 'ME', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '385', 'HR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '386', 'SI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '387', 'BA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '389', 'MK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '39', 'IT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '40', 'RO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '41', 'CH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '420', 'CZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '421', 'SK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '423', 'LI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '43', 'AT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '44', 'GG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '44', 'IM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '44', 'JE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '44', 'GB', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '45', 'DK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '46', 'SE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '47', 'BV', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '47', 'NO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '47', 'SJ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '48', 'PL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '49', 'DE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '500', 'FK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '500', 'GS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '501', 'BZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '502', 'GT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '503', 'SV', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '504', 'HN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '505', 'NI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '506', 'CR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '507', 'PA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '508', 'PM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '509', 'HT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '51', 'PE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '52', 'MX', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '53', 'CU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '54', 'AR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '55', 'BR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '56', 'CL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '57', 'CO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '58', 'VE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '590', 'GP', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '590', 'BL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '590', 'MF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '591', 'BO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '592', 'GY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '593', 'EC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '594', 'GF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '595', 'PY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '596', 'MQ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '597', 'SR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '598', 'UY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '599', 'BQ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '599', 'CW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '60', 'MY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '61', 'AU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '61', 'CX', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '61', 'CC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '62', 'ID', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '63', 'PH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '64', 'NZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '65', 'SG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '66', 'TH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '670', 'TL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '672', 'AQ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '672', 'HM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '672', 'NF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '673', 'BN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '674', 'NR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '675', 'PG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '676', 'TO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '677', 'SB', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '678', 'VU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '679', 'FJ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '680', 'PW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '681', 'WF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '682', 'CK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '683', 'NU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '685', 'WS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '686', 'KI', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '687', 'NC', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '688', 'TV', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '689', 'PF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '690', 'TK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '691', 'FM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '692', 'MH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '7', 'KZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '7', 'RU', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '81', 'JP', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '82', 'KR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '84', 'VN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '850', 'KP', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '852', 'HK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '853', 'MO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '855', 'KH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '856', 'LA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '86', 'CN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '870', 'PN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '880', 'BD', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '886', 'TW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '90', 'TR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '91', 'IN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '92', 'PK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '93', 'AF', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '94', 'LK', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '95', 'MM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '960', 'MV', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '961', 'LB', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '962', 'JO', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '963', 'SY', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '964', 'IQ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '965', 'KW', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '966', 'SA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '967', 'YE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '968', 'OM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '970', 'PS', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '971', 'AE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '972', 'IL', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '973', 'BH', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '974', 'QA', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '975', 'BT', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '976', 'MN', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '977', 'NP', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '98', 'IR', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '992', 'TJ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '993', 'TM', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '994', 'AZ', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '995', 'GE', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '996', 'KG', 0 );
insert into @CountryCallingCode( PhoneNumberPrefix, Iso3166Name, RegionPrefixId ) values( '998', 'UZ', 0 );

declare @PrefixId int;
declare @Iso3166Name varchar( 2 );
declare @RegionPrefixId int;
declare @PhoneNumberPrefix varchar( 4 );
declare @CCountryCallingCode cursor;
set @CCountryCallingCode = cursor static for
    select c.PhoneNumberPrefix
    from @CountryCallingCode c
    group by c.PhoneNumberPrefix;

open @CCountryCallingCode;

fetch next from @CCountryCallingCode into @PhoneNumberPrefix;

while @@fetch_status = 0  
begin
    insert into CK.tPhoneNumberPrefix default values;
    set @PrefixId = scope_identity();
    insert into CK.tRegionCallingCode( PrefixId, PhoneNumberPrefix ) values( @PrefixId, @PhoneNumberPrefix );
    update @CountryCallingCode set RegionPrefixId = @PrefixId where PhoneNumberPrefix = @PhoneNumberPrefix;
    fetch next from @CCountryCallingCode into @PhoneNumberPrefix;
end

close @CCountryCallingCode;
deallocate @CCountryCallingCode;

set @CCountryCallingCode = cursor static for
    select c.Iso3166Name, c.RegionPrefixId
    from @CountryCallingCode c;

open @CCountryCallingCode;

fetch next from @CCountryCallingCode into @Iso3166Name, @RegionPrefixId;

while @@fetch_status = 0  
begin
    insert into CK.tPhoneNumberPrefix default values;
    set @PrefixId = scope_identity();
    insert into CK.tCountryCallingCode( PrefixId, RegionPrefixId, Iso3166Name ) values( @PrefixId, @RegionPrefixId, @Iso3166Name );
    fetch next from @CCountryCallingCode into @Iso3166Name, @RegionPrefixId;
end

close @CCountryCallingCode;
deallocate @CCountryCallingCode;

--[endscript]
