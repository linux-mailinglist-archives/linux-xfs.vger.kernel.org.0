Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE88B64E14
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 23:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfGJVoh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 17:44:37 -0400
Received: from sandeen.net ([63.231.237.45]:46448 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfGJVoh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jul 2019 17:44:37 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 25B5E2B08;
        Wed, 10 Jul 2019 16:44:29 -0500 (CDT)
Subject: Re: [PATCH] Fix the inconsistency between the code and the manual
 page of mkfs.xfs.
To:     Alvin@linux.alibaba.com, linux-xfs@vger.kernel.org,
        sandeen@redhat.com
Cc:     caspar@linux.alibaba.com
References: <1560421580-22920-1-git-send-email-Alvin@linux.alibaba.com>
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
Message-ID: <aa442f3b-e0ee-ea55-efcd-9aa3a499fdec@sandeen.net>
Date:   Wed, 10 Jul 2019 16:44:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1560421580-22920-1-git-send-email-Alvin@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/13/19 5:26 AM, Alvin@linux.alibaba.com wrote:
> From: Alvin Zheng <Alvin@linux.alibaba.com>
> 
> Signed-off-by: Alvin Zheng <Alvin@linux.alibaba.com>

Sorry for getting to this so late.  First of all, we need a descriptive
changelog, something like:



mkfs.xfs.8: Fix an inconsistency between the code and the man page

The man page currently states that block and sector size units cannot
be used for other option values unless they are explicitly specified,
when in fact the default sizes will be used in that case.

Change the man page to clarify this.


> ---
>  man/man8/mkfs.xfs.8 | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c..bf2ad54 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -115,9 +115,12 @@ When specifying parameters in units of sectors or filesystem blocks, the
>  .B \-s
>  option or the
>  .B \-b
> -option first needs to be added to the command line.
> -Failure to specify the size of the units will result in illegal value errors
> -when parameters are quantified in those units.
> +option can be used to specify the size of the sector or block. The 

trailing whitespace there

> +.B \-s
> +option and the
> +.B \-b
> +should be placed before any options in units of sectors or blocks. If the size of the block
> +or sector is not specified, the default size (block: 4KiB, sector: 512B) will be used.

 > 80 col lines.

But also, it seems that it's not actually necessary to state them first, as this works
as expected:

# mkfs/mkfs.xfs -d size=65536b,file,name=fsfile -b size=2k
                        ^^^^^^                     ^^^^^^^
meta-data=fsfile                 isize=512    agcount=4, agsize=16384 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=2048   blocks=65536, imaxpct=25
                                       ^^^^          ^^^^^
         =                       sunit=0      swidth=0 blks

...

# mkfs/mkfs.xfs -d size=65536s,file,name=fsfile -s size=2k
                        ^^^^^^                     ^^^^^^^
meta-data=fsfile                 isize=512    agcount=4, agsize=8192 blks
         =                       sectsz=2048  attr=2, projid32bit=1
                                        ^^^^
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=32768, imaxpct=25
                                                     ^^^^^
         =                       sunit=0      swidth=0 blks

I think this is because we only parse the string to start:

data_opts_parser()

        case D_SIZE:
                cli->dsize = getstr(value, opts, subopt);
                break;

and in fact this is true for all the things that can take this type of unit:

        /* parameters that depend on sector/block size being validated. */
        char    *dsize;
        char    *agsize;
        char    *dsu;
        char    *dirblocksize;
        char    *logsize;
        char    *lsu;
        char    *rtextsize;
        char    *rtsize;

So we validate blocksize & sector size and move them from cli or defaults
into cfg, as needed:

        validate_blocksize(&cfg, &cli, &dft);
        validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
                            force_overwrite);

and from then on we can start converting other sizes using those units:

        /*
         * we've now completed basic validation of the features, sector and
         * block sizes, so from this point onwards we use the values found in
         * the cfg structure for them, not the command line structure.
         */ 
        validate_dirblocksize(&cfg, &cli);
        validate_inodesize(&cfg, &cli); 
...

so I think the changes which indicate that -s size and -b size must be stated
first are not actually correct, as it was intentional to handle them being
stated in any order.  (I know Dave said otherwise, but I think he was 
wrong, and he forgot how he wrote this code) ;)

-Eric

>  .PP
>  Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
> @@ -136,9 +139,10 @@ The filesystem block size is specified with a
>  in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and the
>  maximum is 65536 (64 KiB).
>  .IP
> -To specify any options on the command line in units of filesystem blocks, this
> -option must be specified first so that the filesystem block size is
> -applied consistently to all options.
> +If a non-default filesystem block size is specified, the option
> +must be specified before any options that use filesystem block size
> +units so that the non-default filesystem block size is applied
> +consistently to all options.
>  .IP
>  Although
>  .B mkfs.xfs
> @@ -895,9 +899,10 @@ is 512 bytes. The minimum value for sector size is
>  must be a power of 2 size and cannot be made larger than the
>  filesystem block size.
>  .IP
> -To specify any options on the command line in units of sectors, this
> -option must be specified first so that the sector size is
> -applied consistently to all options.
> +If a non-default sector size is specified, the option
> +must be specified before any options that use sector size
> +units so that the non-default sector size is applied
> +consistently to all options.
>  .RE
>  .TP
>  .BI \-L " label"
> 
