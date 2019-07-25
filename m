Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8F754A3
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 18:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbfGYQxS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 12:53:18 -0400
Received: from relayout03-q01.e.movistar.es ([86.109.101.161]:52925 "EHLO
        relayout03-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729083AbfGYQxS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 12:53:18 -0400
Received: from relayout03-redir.e.movistar.es (unknown [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 45vdZL3pnGzQjvB
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 18:53:14 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout03.e.movistar.es (Postfix) with ESMTPSA id 45vdZG6mYczMlSJ
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 18:53:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 6270B320B40
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 18:53:10 +0200 (CEST)
X-Virus-Scanned: amavisd-new at valinor
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id hyAnqejoGd7s for <linux-xfs@vger.kernel.org>;
        Thu, 25 Jul 2019 18:53:10 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 048193206C6
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 18:53:09 +0200 (CEST)
Subject: Re: Sanity check - need a second pair of eyes ;-) -- DVD mount error
To:     Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
 <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
 <20190725121154.pewwwdpgejcrgdi7@pegasus.maiolino.io>
From:   "Carlos E. R." <robin.listas@telefonica.net>
Openpgp: preference=signencrypt
Autocrypt: addr=robin.listas@telefonica.net; prefer-encrypt=mutual; keydata=
 mQGiBEBfUmURBADiQy6hqnDUs980vU7Pi0qm/JnurLnZUDDEf8k7H10UnKi8E3ySztQuWsPK
 12ccfWCHMKboluffBQA3jf0h1Rl6VZ9brU+rNuqy1eE8bkILhLkoZrsNGXWtzOvRHVSF7dhb
 GBuuFeqdGiRJPSvezQAi3S8dgXugSLZvbyHV97rATwCgmYzZ9mLrTV9RPMJy07K9SY2ZFFkD
 /1rvNuU1teq5hm4naypOFrfO2X4foo9+UjuqZpcPnxD4LEfyrjpx5QVNi3zEDGIAbN7exo4X
 s3VDWnrYZ8lqno4LfTlbuFcgLbAllhW7tYFg4sNW1dWr29VQjghZ8le+Fucx2VJOwv6ILWOr
 O7Qgj61HUvWlR+doKxQBOxFk50IiBACuUBaWimjjbJKvGjMRimJWdGHHxwo+oMA2ZLnsS7wJ
 cSIthF8FC8c1pyJwWcLiYcViy3kypJPloTiQqaZqhVx0ouCYFHBOYLaacCddJ7r6KHZyrjjo
 SegO1vIJn2Y9TolJfuHMNb276A+JPb3gHqm1bfcNHmduKa0gK2NyEkKGWbQwQ2FybG9zIEUu
 IFIuIChjZXIpIDxyb2Jpbi5saXN0YXNAdGVsZWZvbmljYS5uZXQ+iGEEExECACECGwMGCwkI
 BwMCAxUCAwMWAgECHgECF4AFAkfpXpcCGQEACgkQtTMYHG2NR9V4DwCePcfkI8iZtIo9WV1O
 K/ZB8CgMQcMAmwb/JZLJitq0tbzrWeKLZshwGr5puQENBEBfUmYQBACWLO2NmHMU9VM+eTt8
 91cIFfXuhdGBXo3rtQx6Ybgh6tgeag0Rziij7xtlgdtWyM+Gj2cSK5M74P3IOiPKp/ALpneW
 mYEq/11E0zyXPWC5TOXu1/kBfrRvR7sTwB/cXthHESq1j+eEOF//4h0sWrCCKWVwNe7NRy4E
 XbA6culWCwADBQP/c4MCf14YU1qaIQly79ZgNsSZPq/QiVLFI9LG3asrS1OdiPskVS1GN4OD
 BaedOGpUcMa/iwabRILH+d3l7lNIBvZ18aRZN85breq9BCmb0AIYgmZiUL2W5dxXh2gQPaqI
 vF7yvRuGuY5YzC5KqJ7Glpa2wzZ84IdoWAEVMZ+j/uSIRgQYEQIABgUCQF9SZgAKCRC1Mxgc
 bY1H1br5AKCHpABJhGBMGIozLmKiXQ+2MnFknQCeJZx7e+LQJKDrq4ti5MyK6Hjh1+I=
Message-ID: <dac27fde-0b17-4e85-1756-10491c68976a@telefonica.net>
Date:   Thu, 25 Jul 2019 18:53:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190725121154.pewwwdpgejcrgdi7@pegasus.maiolino.io>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aYMjxbVjAegookoqIDnQGopJUF0izqRIK"
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 88.9.30.70 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout03
X-TnetOut-MsgID: 45vdZG6mYczMlSJ.A5DFB
X-TnetOut-SpamCheck: no es spam (whitelisted), Unknown
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1564678393.2874@Q/IS56dkcmOd95z/4OmcEQ
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aYMjxbVjAegookoqIDnQGopJUF0izqRIK
Content-Type: multipart/mixed; boundary="DYXpxO1mnU1xQxrxBLPrUMW108QZDEpBB";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <dac27fde-0b17-4e85-1756-10491c68976a@telefonica.net>
Subject: Re: Sanity check - need a second pair of eyes ;-) -- DVD mount error
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
 <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
 <20190725121154.pewwwdpgejcrgdi7@pegasus.maiolino.io>
In-Reply-To: <20190725121154.pewwwdpgejcrgdi7@pegasus.maiolino.io>

--DYXpxO1mnU1xQxrxBLPrUMW108QZDEpBB
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 25/07/2019 14.11, Carlos Maiolino wrote:

> But I apologize if it's a dumb question, but what do you expect to achi=
eve by
> setting the sector size here? You will be essentially writing the fs im=
age file
> over the BluRay Filesystem (which IIRC uses UDF), so, the sector size s=
et on
> your xfs filesystem image won't matter much, unless I'm missing somethi=
ng, which
> is exactly why I'm asking it :)

Not dumb question - I'm burning directly the XFS image raw to the DVD, as=
 if it were an ISO :-)

But the image is encrypted with LUKS - that's the purpose, to get encrypt=
ed DVDs. password protected UDF would be fine, though, but no such thing =
exists.

I have not used the procedure for years, though. DVD are too small; now I=
 got a blueray writer I'm trying again after a decade.

The basic procedure is this: <https://www.frederickding.com/posts/2017/08=
/luks-encrypted-dvd-bd-data-disc-guide-273316/>, but my procedure is olde=
r than that, I created it myself IIRC.

This is the configuration; file /etc/crypttab contains:

crmm_dvd.l      /dev/dvd.l                                      none    n=
oauto,loop
crmm_dvd.lr     /dev/dvd.lr                                     none    n=
oauto,loop
crmm_dvd.lx     /dev/dvd.lx                                     none    n=
oauto,loop

(tried also without "loop")
/dev/dvd.lx is a symlink to /dev/dvd


/etc/fstab:

/dev/mapper/crmm_dvd.l          /mnt/dvd.crypta.l       auto            r=
o,noauto,user,lazytime                 0 0
/dev/mapper/crmm_dvd.lr         /mnt/dvd.crypta.lr      reiserfs        r=
o,noauto,user,lazytime,barrier=3Dflush   0 0
/dev/mapper/crmm_dvd.lx         /mnt/dvd.crypta.lx      xfs             r=
o,noauto,user,lazytime                 0 0


(I have a script to automate decoding and mount, but this time I'm doing =
manually to show the steps)


I'm getting a problem on mount, though :


=2E.. # cryptsetup luksOpen /dev/dvd crmm_dvd.lx
Enter passphrase for /dev/dvd:=20
=2E.. # l /dev/mapper/
total 0
drwxr-xr-x  2 root root     120 Jul 25 18:17 ./
drwxr-xr-x 22 root root    7580 Jul 25 18:16 ../
crw-------  1 root root 10, 236 Jul 23 11:41 control
=2E..
lrwxrwxrwx  1 root root       7 Jul 25 18:17 crmm_dvd.lx -> ../dm-2
=2E.. #=20

=2E.. # mount -v /dev/mapper/crmm_dvd.lx /mnt/dvd.crypta.lx
mount: /mnt/dvd.crypta.lx: mount(2) system call failed: Function not impl=
emented.   <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D HERE =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 #=20


Possible related to this log entry:

<0.4> 2019-07-25 18:19:19 Telcontar kernel - - - [127181.795181] XFS (dm-=
2): device supports 2048 byte sectors (not 512)



This worked years ago with plain DVDs. I can mount the dd image out of th=
e dvd into the hard disk, though:

dd if=3D/dev/dvd of=3Dout.img bs=3D16M
BLUERAY_OPS # losetup -f out.img
BLUERAY_OPS # losetup -a
/dev/loop1: [2087]:1209048961 (/home_aux/BLUERAY_OPS/out.img)
/dev/loop0: [2087]:1209048958 (/home_aux/BLUERAY_OPS/image_1_50.img)
BLUERAY_OPS # cryptsetup luksOpen /dev/loop1 cr_dvdimage
Enter passphrase for /dev/loop1:=20
BLUERAY_OPS # md mnt2
BLUERAY_OPS # mount -v /dev/mapper/cr_dvdimage ./mnt2
mount: /dev/mapper/cr_dvdimage mounted on /home_aux/BLUERAY_OPS/mnt2.
BLUERAY_OPS #=20

BLUERAY_OPS # file out.img=20
out.img: LUKS encrypted file, ver 2 [, , sha256] UUID: 0f73c10a-b3e0-4b1b=
-b124-567abef92fa1
Telcontar:/home_aux/BLUERAY_OPS #

BLUERAY_OPS # file -s /dev/mapper/cr_dvdimage
/dev/mapper/cr_dvdimage: symbolic link to ../dm-3
BLUERAY_OPS # file -s /dev/dm-3
/dev/dm-3: SGI XFS filesystem data (blksz 2048, inosz 512, v2 dirs)
BLUERAY_OPS #=20

BLUERAY_OPS # file -s /dev/dm-2     # that's the decoded DVD
/dev/dm-2: SGI XFS filesystem data (blksz 2048, inosz 512, v2 dirs)
BLUERAY_OPS=20

Telcontar:/home_aux/BLUERAY_OPS # df -h ./mnt2
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/cr_dvdimage   47G   47G  183M 100% /home_aux/BLUERAY_OPS/mnt2=

Telcontar:/home_aux/BLUERAY_OPS #=20

Telcontar:/home_aux/BLUERAY_OPS # df -H ./mnt2
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/cr_dvdimage   51G   50G  192M 100% /home_aux/BLUERAY_OPS/mnt2=

Telcontar:/home_aux/BLUERAY_OPS #=20




--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--DYXpxO1mnU1xQxrxBLPrUMW108QZDEpBB--

--aYMjxbVjAegookoqIDnQGopJUF0izqRIK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXTnebAAKCRC1MxgcbY1H
1VPEAJ9vmfo0HFdIQazZVLxY6T1vw4UzoACfZNxf5JxcHhbJwNLqN8FLRsC42h8=
=BXKC
-----END PGP SIGNATURE-----

--aYMjxbVjAegookoqIDnQGopJUF0izqRIK--
