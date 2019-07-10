Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CC264C0F
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Jul 2019 20:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfGJS2E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jul 2019 14:28:04 -0400
Received: from relayout01-q02.e.movistar.es ([86.109.101.142]:45279 "EHLO
        relayout01-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727242AbfGJS2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 14:28:04 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2019 14:28:03 EDT
Received: from relayout01-redir.e.movistar.es (relayout01-redir.e.movistar.es [86.109.101.201])
        by relayout01-out.e.movistar.es (Postfix) with ESMTP id 45kSFc3t1PzjYWF;
        Wed, 10 Jul 2019 20:21:56 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout01.e.movistar.es (Postfix) with ESMTPSA id 45kSFc0JG9zfZXM;
        Wed, 10 Jul 2019 20:21:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 3D162320B3B;
        Wed, 10 Jul 2019 20:21:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at valinor
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id LZf7QZFqCvfN; Wed, 10 Jul 2019 20:21:55 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id F01E8320B2A;
        Wed, 10 Jul 2019 20:21:54 +0200 (CEST)
Subject: Re: Need help to recover root filesystem after a power supply issue
To:     Andrey Zhunev <a-j@a-j.ru>,
        Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <871210488.20190710125617@a-j.ru>
 <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
 <433120592.20190710165841@a-j.ru>
 <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
 <15810023599.20190710180230@a-j.ru>
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
Message-ID: <4160fe6c-329c-1e80-c6ed-804a967157f6@telefonica.net>
Date:   Wed, 10 Jul 2019 20:21:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <15810023599.20190710180230@a-j.ru>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK"
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 88.9.30.70 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout01
X-TnetOut-MsgID: 45kSFc0JG9zfZXM.AFAE8
X-TnetOut-SpamCheck: no es spam (whitelisted), Unknown
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1563387716.39618@ltsAFHg0ny/0AsLr5FAOgw
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK
Content-Type: multipart/mixed; boundary="G08qvOeFIzjxLjP3NuAwjA2XIPVAOT9B2";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Andrey Zhunev <a-j@a-j.ru>,
 Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <4160fe6c-329c-1e80-c6ed-804a967157f6@telefonica.net>
Subject: Re: Need help to recover root filesystem after a power supply issue
References: <871210488.20190710125617@a-j.ru>
 <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
 <433120592.20190710165841@a-j.ru>
 <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
 <15810023599.20190710180230@a-j.ru>
In-Reply-To: <15810023599.20190710180230@a-j.ru>

--G08qvOeFIzjxLjP3NuAwjA2XIPVAOT9B2
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 10/07/2019 17.02, Andrey Zhunev wrote:

> Ooops, I forgot to paste the error message from dmesg.
> Here it is:
>=20
> Jul 10 11:48:05 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x180000=
 SErr 0x0 action 0x0
> Jul 10 11:48:05 mgmt kernel: ata1.00: irq_stat 0x40000008
> Jul 10 11:48:05 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED=

> Jul 10 11:48:05 mgmt kernel: ata1.00: cmd 60/00:98:28:ac:3e/01:00:03:00=
:00/40 tag 19 ncq 131072 in#012         res 41/40:00:08:ad:3e/00:00:03:00=
:00/40 Emask 0x409 (media error) <F>
> Jul 10 11:48:05 mgmt kernel: ata1.00: status: { DRDY ERR }
> Jul 10 11:48:05 mgmt kernel: ata1.00: error: { UNC }
> Jul 10 11:48:05 mgmt kernel: ata1.00: configured for UDMA/133
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 FAILED Result: ho=
stbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Sense Key : Mediu=
m Error [current] [descriptor]
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Add. Sense: Unrec=
overed read error - auto reallocate failed
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 CDB: Read(16) 88 =
00 00 00 00 00 03 3e ac 28 00 00 01 00 00 00
> Jul 10 11:48:05 mgmt kernel: blk_update_request: I/O error, dev sda, se=
ctor 54439176
> Jul 10 11:48:05 mgmt kernel: ata1: EH complete
>=20
> There are several of these.
> At the moment ddrescue reports 22 read errors (with 35% of the data
> copied to a new storage). If I remember correctly, the LVM with my
> root partition is at the end of the drive. This means more errors will
> likely come... :(=20
>=20
> The way I interpret the dmesg message, that's just a read error.

"auto realocate failed" is important. Might indicate the realocation
area is full :-?

> I'm
> not sure, but maybe a complete wipe of the drive will even overwrite /
> clear these unreadable sectors.
> Well, that's something to be checked after the copy process finishes.

Run the SMART long test after you have made a copy, and watch specially
for the Current_Pending_Sector, Offline_Uncorrectable, and
Reallocated_Sector_Ct values. Then overwrite the entire disk with zeroes
and repeat the test. If the bad sector number increases, dump the disk.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--G08qvOeFIzjxLjP3NuAwjA2XIPVAOT9B2--

--IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXSYsuQAKCRC1MxgcbY1H
1UmEAJ4jIJDJiuFGukJ0rZ6mOMZEL0r6nQCfe4qk37Ldb1moFONRZLWHjjc2gm4=
=mxf9
-----END PGP SIGNATURE-----

--IdKG5kE77Nfg5iCcN5TZ2Z66HiltE6ekK--
