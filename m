Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D0264978
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 17:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGJPXV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 11:23:21 -0400
Received: from sandeen.net ([63.231.237.45]:41478 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfGJPXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jul 2019 11:23:21 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 15440323BFA;
        Wed, 10 Jul 2019 10:23:13 -0500 (CDT)
Subject: Re: Need help to recover root filesystem after a power supply issue
To:     Andrey Zhunev <a-j@a-j.ru>, linux-xfs@vger.kernel.org
References: <871210488.20190710125617@a-j.ru>
 <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
 <433120592.20190710165841@a-j.ru>
 <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
 <15810023599.20190710180230@a-j.ru>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCVFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgAUCUzMzbAIZAQAKCRAgrhaS4T3e4Fr7D/wO+fenqVvHjq21SCjDCrt8HdVj
 aJ28B1SqSU2toxyg5I160GllAxEHpLFGdbFAhQfBtnmlY9eMjwmJb0sCIrkrB6XNPSPA/B2B
 UPISh0z2odJv35/euJF71qIFgWzp2czJHkHWwVZaZpMWWNvsLIroXoR+uA9c2V1hQFVAJZyk
 EE4xzfm1+oVtjIC12B9tTCuS00pY3AUy21yzNowT6SSk7HAzmtG/PJ/uSB5wEkwldB6jVs2A
 sjOg1wMwVvh/JHilsQg4HSmDfObmZj1d0RWlMWcUE7csRnCE0ZWBMp/ttTn+oosioGa09HAS
 9jAnauznmYg43oQ5Akd8iQRxz5I58F/+JsdKvWiyrPDfYZtFS+UIgWD7x+mHBZ53Qjazszox
 gjwO9ehZpwUQxBm4I0lPDAKw3HJA+GwwiubTSlq5PS3P7QoCjaV8llH1bNFZMz2o8wPANiDx
 5FHgpRVgwLHakoCU1Gc+LXHXBzDXt7Cj02WYHdFzMm2hXaslRdhNGowLo1SXZFXa41KGTlNe
 4di53y9CK5ynV0z+YUa+5LR6RdHrHtgywdKnjeWdqhoVpsWIeORtwWGX8evNOiKJ7j0RsHha
 WrePTubr5nuYTDsQqgc2r4aBIOpeSRR2brlT/UE3wGgy9LY78L4EwPR0MzzecfE1Ws60iSqw
 Pu3vhb7h3bkCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJ
 X4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTEajUY0Up+b3ErOpLpZwhvgWatjifpj6bB
 SKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA
 2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuC
 GV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG5
 1u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
 Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQHngeN5fPx
 ze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3jAQnsWTru4RV
 TZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5etheLMO
 gRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQY
 AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0ki
 YPveGoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWN
 mcQT78hBeGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/
 LKjxnTedX0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
 LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0
 MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+
 JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBO
 Pk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/
 m1F3vYvdlE4p2ts1mmixMF7KajN9/E5RQtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlf
 fWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLX pA==
Message-ID: <2c813b5e-5930-0e3d-db98-d7cab1bcf562@sandeen.net>
Date:   Wed, 10 Jul 2019 10:23:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <15810023599.20190710180230@a-j.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 7/10/19 10:02 AM, Andrey Zhunev wrote:
> Wednesday, July 10, 2019, 5:23:41 PM, you wrote:
...

 
>> As I said, look at dmesg to see what failed on the original drive read
>> attempt.
> 
>> ddrescue will fill unreadable sectors with 0, and then of course that
>> can be read from the image file.
> 
> 
> Ooops, I forgot to paste the error message from dmesg.
> Here it is:
> 
> Jul 10 11:48:05 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x180000 SErr 0x0 action 0x0
> Jul 10 11:48:05 mgmt kernel: ata1.00: irq_stat 0x40000008
> Jul 10 11:48:05 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED
> Jul 10 11:48:05 mgmt kernel: ata1.00: cmd 60/00:98:28:ac:3e/01:00:03:00:00/40 tag 19 ncq 131072 in#012         res 41/40:00:08:ad:3e/00:00:03:00:00/40 Emask 0x409 (media error) <F>
> Jul 10 11:48:05 mgmt kernel: ata1.00: status: { DRDY ERR }
> Jul 10 11:48:05 mgmt kernel: ata1.00: error: { UNC }
> Jul 10 11:48:05 mgmt kernel: ata1.00: configured for UDMA/133
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Sense Key : Medium Error [current] [descriptor]
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Add. Sense: Unrecovered read error - auto reallocate failed
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 CDB: Read(16) 88 00 00 00 00 00 03 3e ac 28 00 00 01 00 00 00
> Jul 10 11:48:05 mgmt kernel: blk_update_request: I/O error, dev sda, sector 54439176
> Jul 10 11:48:05 mgmt kernel: ata1: EH complete
> 
> There are several of these.
> At the moment ddrescue reports 22 read errors (with 35% of the data
> copied to a new storage). If I remember correctly, the LVM with my
> root partition is at the end of the drive. This means more errors will
> likely come... :( 
> 
> The way I interpret the dmesg message, that's just a read error. I'm
> not sure, but maybe a complete wipe of the drive will even overwrite /
> clear these unreadable sectors.
> Well, that's something to be checked after the copy process finishes.

Yep so hardware error, ddrescue will fill unreadable sectors with zeros, then you
can see whether or not xfs_repair can cope with what is left.

overwriting the sectors may "fix" them but I would never trust that drive
after this, personally.  ;)

-Eric
