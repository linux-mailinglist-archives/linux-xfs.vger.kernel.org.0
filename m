Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3207A156966
	for <lists+linux-xfs@lfdr.de>; Sun,  9 Feb 2020 07:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgBIGTs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 9 Feb 2020 01:19:48 -0500
Received: from outbound2m.ore.mailhop.org ([54.149.155.156]:38878 "EHLO
        outbound2m.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbgBIGTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Feb 2020 01:19:48 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1581229183; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=wRpCIXXzXjeIOEowSPD+f3B6hmHIfC2rCcgHKm7p0fnxYcwEFtmGDa03wiFqcCIHVBwkE2fKvrQXw
         5HLltXVyT6SdfFB2iMB+QYqPdXaTTAoTI19nvukmG+Ji4fTtk8wvK569n7s8WtsgGLlW6Mk+C2RK27
         E6kOP0A0ZhZKXNGKjM0slrWH1inD4i5HtWtUIUZN4U8i1+Db0s7iLrsc5YRhe4/XxfL9OUqEUMhoMc
         ogKlmD2H5/LX6IlA4zqsVpywqjK9fiUHud+mRGI+2e3Y4K9gLX/TTClii4NPLGVmrsk9LVwVjFgqql
         p7WhttYpisJ+XuOiU6XFENzPHgAyK7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=mime-version:content-type:in-reply-to:references:message-id:date:subject:to:
         from:dkim-signature:dkim-signature:from;
        bh=jR+cteaAeOjb3xH8n4hXQSqRO0wWIzHgAliZUyBCZRk=;
        b=p5j2f3OCtXKCopJP/WQ8nSYYKuYLCxn2t0OZbTTEp58pSbpE2oGk6JBRj4ipP3/n2GL6d9K6rFrGF
         ZNWFQCJ0TwyIZP6R024DZWpGPTtXfdmuyGlNMXQfEempfxr9gWV/BhZhp0Cv8Nz6GFS4bw1I65NDYp
         Uj8zv4JTgIN4r65pXEEULu4CGydMVq5BUjkIts27KVR9RpmB671FkLATKcfP5BFjRCn+KhoV6XuUL5
         Q2Bmv0XmdxNHGnrLwNfFk03XonH95mccjrJwQKGyyHsOIjnP1HUPjEEE95On9y3oclriNYaXdcNZSX
         mt+h97x7eKoOgyh4TtXygaIlmZK2GKQ==
ARC-Authentication-Results: i=1; outbound4.ore.mailhop.org;
        spf=pass smtp.mailfrom=jore.no smtp.remote-ip=27.96.199.243;
        dmarc=none header.from=jore.no;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jore.no; s=duo-1579427507040-bf9c4b8d;
        h=mime-version:content-type:in-reply-to:references:message-id:date:subject:to:
         from:from;
        bh=jR+cteaAeOjb3xH8n4hXQSqRO0wWIzHgAliZUyBCZRk=;
        b=RgvN1ukl8t04mINUtXoPT8yv0tKWQxldovv0DICganCanGX2emSx0GP55zXHvVvvwr+GJ9Tsbm4Ve
         rdXXWRzYPDhFDsnYtl19ZwROkS+QQXBCOpa3y+vOcALZh3tBec1+WDBTCoOK5lT7zCwMirRv7JQtH0
         heJtyudj2bp8sT7k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=mime-version:content-type:in-reply-to:references:message-id:date:subject:to:
         from:from;
        bh=jR+cteaAeOjb3xH8n4hXQSqRO0wWIzHgAliZUyBCZRk=;
        b=LPnNGgrZfdFWlbqETd7FKvvEOqlpFcMjm2FZKovbm8CO/APYlr8tj9wwCYmi+tSyQk4y1AvDYAZTg
         eOx8PiESjUaUz149hzS9cs4hejRgGbYm1cYTB783QpUnnNqM58B64o1us/46HSGfrILfTEOXPbvvoe
         TMBaNkaJmNSAUmdUwXKY6RienfJDNj7jFon5riv3p8iCgZ1VYoFtnO1KvWxXq8FKoqHkfXPR/amnIL
         7SE+5bf7eWNRf+6TnPx4HIMmoQzA3oJeOe1zGAmmFZmZq/y28fmkYcRWNK5f5Hz6s8D/1j8c2m1jg0
         TXAX0SHsQnG2XYDDrF0hXCCppIdy6DQ==
X-MHO-RoutePath: am9obmpvcmU=
X-MHO-User: 25ab61a5-4b04-11ea-9eb3-25e2dfa9fa8d
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mail.jore.no (unknown [27.96.199.243])
        by outbound4.ore.mailhop.org (Halon) with ESMTPSA
        id 25ab61a5-4b04-11ea-9eb3-25e2dfa9fa8d;
        Sun, 09 Feb 2020 06:19:40 +0000 (UTC)
Received: from SNHNEXE02.skynet.net (192.168.1.14) by SNHNEXE02.skynet.net
 (192.168.1.14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.330.5; Sun, 9 Feb 2020
 17:19:35 +1100
Received: from SNHNEXE02.skynet.net ([fe80::ad3a:937:9347:f03b]) by
 SNHNEXE02.skynet.net ([fe80::ad3a:937:9347:f03b%12]) with mapi id
 15.02.0330.010; Sun, 9 Feb 2020 17:19:35 +1100
From:   John Jore <john@jore.no>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Bug in xfs_repair 5..4.0 / Unable to repair metadata corruption
Thread-Topic: Bug in xfs_repair 5..4.0 / Unable to repair metadata corruption
Thread-Index: AQHV3woCeKF9LncMXUyAW7OQrNKp4qgSYvxV
Date:   Sun, 9 Feb 2020 06:19:34 +0000
Message-ID: <b2babb761ed24dc986abc3073c5c47fc@jore.no>
References: <186d30f217e645728ad1f34724cbe3e7@jore.no>
In-Reply-To: <186d30f217e645728ad1f34724cbe3e7@jore.no>
Accept-Language: en-GB, nb-NO, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
X-Originating-IP: 27.96.199.243
Content-Type: multipart/mixed;
        boundary="_002_b2babb761ed24dc986abc3073c5c47fcjoreno_"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--_002_b2babb761ed24dc986abc3073c5c47fcjoreno_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

Not sure if this is the appropriate forum to reports xfs_repair bugs? If wr=
ong, please point me in the appropriate direction?

I have a corrupted XFS volume which=A0mounts fine, but xfs_repair is unable=
 to repair it and=A0volume eventually=A0shuts down due to metadata corrupti=
on if writes are performed.

Originally I used xfs_repair from=A0CentOS 8.1.1911, but cloned latest xfs_=
repair=A0from=A0git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git (Today=
, Feb 9th, reports as version=A05.4.0)


Phase 3 - for each AG...
=A0 =A0 =A0 =A0 - scan and clear agi unlinked lists...
=A0 =A0 =A0 =A0 - 16:08:04: scanning agi unlinked lists - 64 of 64 allocati=
on groups done
=A0 =A0 =A0 =A0 - process known inodes and perform inode discovery...
=A0 =A0 =A0 =A0 - agno =3D 45
=A0 =A0 =A0 =A0 - agno =3D 15
=A0 =A0 =A0 =A0 - agno =3D 0
=A0 =A0 =A0 =A0 - agno =3D 30
=A0 =A0 =A0 =A0 - agno =3D 60
=A0 =A0 =A0 =A0 - agno =3D 46
=A0 =A0 =A0 =A0 - agno =3D 16
Metadata corruption detected at 0x4330e3, xfs_inode block 0x17312a3f0/0x200=
0
=A0 =A0 =A0 =A0 - agno =3D 61
=A0 =A0 =A0 =A0 - agno =3D 31
=A0 =A0 =A0 =A0 - agno =3D 47
=A0 =A0 =A0 =A0 - agno =3D 62
=A0 =A0 =A0 =A0 - agno =3D 48
=A0 =A0 =A0 =A0 - agno =3D 49
=A0 =A0 =A0 =A0 - agno =3D 32
=A0 =A0 =A0 =A0 - agno =3D 33
=A0 =A0 =A0 =A0 - agno =3D 17
=A0 =A0 =A0 =A0 - agno =3D 1
bad magic number 0x0 on inode 18253615584
bad version number 0x0 on inode 18253615584
bad magic number 0x0 on inode 18253615585
bad version number 0x0 on inode 18253615585
bad magic number 0x0 on inode 18253615586=20
.....
bad magic number 0x0 on inode 18253615584, resetting magic number
bad version number 0x0 on inode 18253615584, resetting version number
bad magic number 0x0 on inode 18253615585, resetting magic number
bad version number 0x0 on inode 18253615585, resetting version number
bad magic number 0x0 on inode 18253615586, resetting magic number
bad version number 0x0 on inode 18253615586, resetting version number
....
=A0 =A0 =A0 =A0 - agno =3D 16
=A0 =A0 =A0 =A0 - agno =3D 17
Metadata corruption detected at 0x4330e3, xfs_inode block 0x17312a3f0/0x200=
0
=A0 =A0 =A0 =A0 - agno =3D 18
=A0 =A0 =A0 =A0 - agno =3D 19
...=A0 =A0
Phase 7 - verify and correct link counts...
=A0 =A0 =A0 =A0 - 16:10:41: verify and correct link counts - 64 of 64 alloc=
ation groups done
Metadata corruption detected at 0x433385, xfs_inode block 0x17312a3f0/0x200=
0
libxfs_writebufr: write verifier failed on xfs_inode bno 0x17312a3f0/0x2000
releasing dirty buffer (bulk) to free list!

=20

Does not matter how many times, I've lost count, I re-run xfs_repair, with,=
 or without -d, it never does repair the volume.
Volume is a ~12GB LV build using=A04x 4TB disks in RAID 5 using a 3Ware 969=
0SA controller.=A0


Any suggestions or additional data I can provide?


John

--_002_b2babb761ed24dc986abc3073c5c47fcjoreno_
Content-Type: application/octet-stream; name="output.log"
Content-Description: output.log
Content-Disposition: attachment; filename="output.log"; size=14757;
	creation-date="Sun, 09 Feb 2020 06:19:25 GMT";
	modification-date="Sun, 09 Feb 2020 06:19:25 GMT"
Content-Transfer-Encoding: base64

UGhhc2UgMSAtIGZpbmQgYW5kIHZlcmlmeSBzdXBlcmJsb2NrLi4uCiAgICAgICAgLSByZXBvcnRp
bmcgcHJvZ3Jlc3MgaW4gaW50ZXJ2YWxzIG9mIDE1IG1pbnV0ZXMKICAgICAgICAtIGJsb2NrIGNh
Y2hlIHNpemUgc2V0IHRvIDU1Njc5MiBlbnRyaWVzClBoYXNlIDIgLSB1c2luZyBpbnRlcm5hbCBs
b2cKICAgICAgICAtIHplcm8gbG9nLi4uCnplcm9fbG9nOiBoZWFkIGJsb2NrIDIxMzc4MSB0YWls
IGJsb2NrIDIxMzc4MQogICAgICAgIC0gc2NhbiBmaWxlc3lzdGVtIGZyZWVzcGFjZSBhbmQgaW5v
ZGUgbWFwcy4uLgogICAgICAgIC0gMTY6MDg6MDQ6IHNjYW5uaW5nIGZpbGVzeXN0ZW0gZnJlZXNw
YWNlIC0gNjQgb2YgNjQgYWxsb2NhdGlvbiBncm91cHMgZG9uZQogICAgICAgIC0gZm91bmQgcm9v
dCBpbm9kZSBjaHVuawpQaGFzZSAzIC0gZm9yIGVhY2ggQUcuLi4KICAgICAgICAtIHNjYW4gYW5k
IGNsZWFyIGFnaSB1bmxpbmtlZCBsaXN0cy4uLgogICAgICAgIC0gMTY6MDg6MDQ6IHNjYW5uaW5n
IGFnaSB1bmxpbmtlZCBsaXN0cyAtIDY0IG9mIDY0IGFsbG9jYXRpb24gZ3JvdXBzIGRvbmUKICAg
ICAgICAtIHByb2Nlc3Mga25vd24gaW5vZGVzIGFuZCBwZXJmb3JtIGlub2RlIGRpc2NvdmVyeS4u
LgogICAgICAgIC0gYWdubyA9IDQ1CiAgICAgICAgLSBhZ25vID0gMTUKICAgICAgICAtIGFnbm8g
PSAwCiAgICAgICAgLSBhZ25vID0gMzAKICAgICAgICAtIGFnbm8gPSA2MAogICAgICAgIC0gYWdu
byA9IDQ2CiAgICAgICAgLSBhZ25vID0gMTYKTWV0YWRhdGEgY29ycnVwdGlvbiBkZXRlY3RlZCBh
dCAweDQzMzBlMywgeGZzX2lub2RlIGJsb2NrIDB4MTczMTJhM2YwLzB4MjAwMAogICAgICAgIC0g
YWdubyA9IDYxCiAgICAgICAgLSBhZ25vID0gMzEKICAgICAgICAtIGFnbm8gPSA0NwogICAgICAg
IC0gYWdubyA9IDYyCiAgICAgICAgLSBhZ25vID0gNDgKICAgICAgICAtIGFnbm8gPSA0OQogICAg
ICAgIC0gYWdubyA9IDMyCiAgICAgICAgLSBhZ25vID0gMzMKICAgICAgICAtIGFnbm8gPSAxNwog
ICAgICAgIC0gYWdubyA9IDEKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1
ODQKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU4NApiYWQgbWFnaWMg
bnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU4NQpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9u
IGlub2RlIDE4MjUzNjE1NTg1CmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1
NTg2CmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1ODYKYmFkIG1hZ2lj
IG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1ODcKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBv
biBpbm9kZSAxODI1MzYxNTU4NwpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYx
NTU4OApiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTg4CmJhZCBtYWdp
YyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTg5CmJhZCB2ZXJzaW9uIG51bWJlciAweDAg
b24gaW5vZGUgMTgyNTM2MTU1ODkKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2
MTU1OTAKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5MApiYWQgbWFn
aWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5MQpiYWQgdmVyc2lvbiBudW1iZXIgMHgw
IG9uIGlub2RlIDE4MjUzNjE1NTkxCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUz
NjE1NTkyCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTIKYmFkIG1h
Z2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTMKYmFkIHZlcnNpb24gbnVtYmVyIDB4
MCBvbiBpbm9kZSAxODI1MzYxNTU5MwpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1
MzYxNTU5NApiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTk0CmJhZCBt
YWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTk1CmJhZCB2ZXJzaW9uIG51bWJlciAw
eDAgb24gaW5vZGUgMTgyNTM2MTU1OTUKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgy
NTM2MTU1OTYKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5NgpiYWQg
bWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5NwpiYWQgdmVyc2lvbiBudW1iZXIg
MHgwIG9uIGlub2RlIDE4MjUzNjE1NTk3CmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4
MjUzNjE1NTk4CmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTgKYmFk
IG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTkKYmFkIHZlcnNpb24gbnVtYmVy
IDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5OQpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAx
ODI1MzYxNTYwMApiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjAwCmJh
ZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjAxCmJhZCB2ZXJzaW9uIG51bWJl
ciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDEKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUg
MTgyNTM2MTU2MDIKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwMgpi
YWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwMwpiYWQgdmVyc2lvbiBudW1i
ZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjAzCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2Rl
IDE4MjUzNjE1NjA0CmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDQK
YmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDUKYmFkIHZlcnNpb24gbnVt
YmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwNQpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9k
ZSAxODI1MzYxNTYwNgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjA2
CmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjA3CmJhZCB2ZXJzaW9uIG51
bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDcKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5v
ZGUgMTgyNTM2MTU2MDgKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYw
OApiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwOQpiYWQgdmVyc2lvbiBu
dW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjA5CmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlu
b2RlIDE4MjUzNjE1NjEwCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2
MTAKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MTEKYmFkIHZlcnNpb24g
bnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYxMQpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBp
bm9kZSAxODI1MzYxNTYxMgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1
NjEyCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjEzCmJhZCB2ZXJzaW9u
IG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MTMKYmFkIG1hZ2ljIG51bWJlciAweDAgb24g
aW5vZGUgMTgyNTM2MTU2MTQKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYx
NTYxNApiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYxNQpiYWQgdmVyc2lv
biBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjE1CmJhZCBtYWdpYyBudW1iZXIgMHgwIG9u
IGlub2RlIDE4MjUzNjE1NTg0LCByZXNldHRpbmcgbWFnaWMgbnVtYmVyCmJhZCB2ZXJzaW9uIG51
bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1ODQsIHJlc2V0dGluZyB2ZXJzaW9uIG51bWJlcgpi
YWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU4NSwgcmVzZXR0aW5nIG1hZ2lj
IG51bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTg1LCByZXNl
dHRpbmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2
MTU1ODYsIHJlc2V0dGluZyBtYWdpYyBudW1iZXIKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBp
bm9kZSAxODI1MzYxNTU4NiwgcmVzZXR0aW5nIHZlcnNpb24gbnVtYmVyCmJhZCBtYWdpYyBudW1i
ZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTg3LCByZXNldHRpbmcgbWFnaWMgbnVtYmVyCmJhZCB2
ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1ODcsIHJlc2V0dGluZyB2ZXJzaW9u
IG51bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU4OCwgcmVzZXR0
aW5nIG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1
NTg4LCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5v
ZGUgMTgyNTM2MTU1ODksIHJlc2V0dGluZyBtYWdpYyBudW1iZXIKYmFkIHZlcnNpb24gbnVtYmVy
IDB4MCBvbiBpbm9kZSAxODI1MzYxNTU4OSwgcmVzZXR0aW5nIHZlcnNpb24gbnVtYmVyCmJhZCBt
YWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTkwLCByZXNldHRpbmcgbWFnaWMgbnVt
YmVyCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTAsIHJlc2V0dGlu
ZyB2ZXJzaW9uIG51bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5
MSwgcmVzZXR0aW5nIG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2Rl
IDE4MjUzNjE1NTkxLCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2ljIG51bWJlciAw
eDAgb24gaW5vZGUgMTgyNTM2MTU1OTIsIHJlc2V0dGluZyBtYWdpYyBudW1iZXIKYmFkIHZlcnNp
b24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5MiwgcmVzZXR0aW5nIHZlcnNpb24gbnVt
YmVyCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTkzLCByZXNldHRpbmcg
bWFnaWMgbnVtYmVyCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTMs
IHJlc2V0dGluZyB2ZXJzaW9uIG51bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAx
ODI1MzYxNTU5NCwgcmVzZXR0aW5nIG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgw
IG9uIGlub2RlIDE4MjUzNjE1NTk0LCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2lj
IG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTUsIHJlc2V0dGluZyBtYWdpYyBudW1iZXIK
YmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5NSwgcmVzZXR0aW5nIHZl
cnNpb24gbnVtYmVyCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTk2LCBy
ZXNldHRpbmcgbWFnaWMgbnVtYmVyCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgy
NTM2MTU1OTYsIHJlc2V0dGluZyB2ZXJzaW9uIG51bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBv
biBpbm9kZSAxODI1MzYxNTU5NywgcmVzZXR0aW5nIG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBu
dW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NTk3LCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIK
YmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU1OTgsIHJlc2V0dGluZyBtYWdp
YyBudW1iZXIKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTU5OCwgcmVz
ZXR0aW5nIHZlcnNpb24gbnVtYmVyCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUz
NjE1NTk5LCByZXNldHRpbmcgbWFnaWMgbnVtYmVyCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24g
aW5vZGUgMTgyNTM2MTU1OTksIHJlc2V0dGluZyB2ZXJzaW9uIG51bWJlcgpiYWQgbWFnaWMgbnVt
YmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwMCwgcmVzZXR0aW5nIG1hZ2ljIG51bWJlcgpiYWQg
dmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjAwLCByZXNldHRpbmcgdmVyc2lv
biBudW1iZXIKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDEsIHJlc2V0
dGluZyBtYWdpYyBudW1iZXIKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYx
NTYwMSwgcmVzZXR0aW5nIHZlcnNpb24gbnVtYmVyCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlu
b2RlIDE4MjUzNjE1NjAyLCByZXNldHRpbmcgbWFnaWMgbnVtYmVyCmJhZCB2ZXJzaW9uIG51bWJl
ciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDIsIHJlc2V0dGluZyB2ZXJzaW9uIG51bWJlcgpiYWQg
bWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwMywgcmVzZXR0aW5nIG1hZ2ljIG51
bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjAzLCByZXNldHRp
bmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2
MDQsIHJlc2V0dGluZyBtYWdpYyBudW1iZXIKYmFkIHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9k
ZSAxODI1MzYxNTYwNCwgcmVzZXR0aW5nIHZlcnNpb24gbnVtYmVyCmJhZCBtYWdpYyBudW1iZXIg
MHgwIG9uIGlub2RlIDE4MjUzNjE1NjA1LCByZXNldHRpbmcgbWFnaWMgbnVtYmVyCmJhZCB2ZXJz
aW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDUsIHJlc2V0dGluZyB2ZXJzaW9uIG51
bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwNiwgcmVzZXR0aW5n
IG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjA2
LCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2ljIG51bWJlciAweDAgb24gaW5vZGUg
MTgyNTM2MTU2MDcsIHJlc2V0dGluZyBtYWdpYyBudW1iZXIKYmFkIHZlcnNpb24gbnVtYmVyIDB4
MCBvbiBpbm9kZSAxODI1MzYxNTYwNywgcmVzZXR0aW5nIHZlcnNpb24gbnVtYmVyCmJhZCBtYWdp
YyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjA4LCByZXNldHRpbmcgbWFnaWMgbnVtYmVy
CmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MDgsIHJlc2V0dGluZyB2
ZXJzaW9uIG51bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYwOSwg
cmVzZXR0aW5nIG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9uIGlub2RlIDE4
MjUzNjE1NjA5LCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2ljIG51bWJlciAweDAg
b24gaW5vZGUgMTgyNTM2MTU2MTAsIHJlc2V0dGluZyBtYWdpYyBudW1iZXIKYmFkIHZlcnNpb24g
bnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYxMCwgcmVzZXR0aW5nIHZlcnNpb24gbnVtYmVy
CmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjExLCByZXNldHRpbmcgbWFn
aWMgbnVtYmVyCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MTEsIHJl
c2V0dGluZyB2ZXJzaW9uIG51bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1
MzYxNTYxMiwgcmVzZXR0aW5nIG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBudW1iZXIgMHgwIG9u
IGlub2RlIDE4MjUzNjE1NjEyLCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIKYmFkIG1hZ2ljIG51
bWJlciAweDAgb24gaW5vZGUgMTgyNTM2MTU2MTMsIHJlc2V0dGluZyBtYWdpYyBudW1iZXIKYmFk
IHZlcnNpb24gbnVtYmVyIDB4MCBvbiBpbm9kZSAxODI1MzYxNTYxMywgcmVzZXR0aW5nIHZlcnNp
b24gbnVtYmVyCmJhZCBtYWdpYyBudW1iZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjE0LCByZXNl
dHRpbmcgbWFnaWMgbnVtYmVyCmJhZCB2ZXJzaW9uIG51bWJlciAweDAgb24gaW5vZGUgMTgyNTM2
MTU2MTQsIHJlc2V0dGluZyB2ZXJzaW9uIG51bWJlcgpiYWQgbWFnaWMgbnVtYmVyIDB4MCBvbiBp
bm9kZSAxODI1MzYxNTYxNSwgcmVzZXR0aW5nIG1hZ2ljIG51bWJlcgpiYWQgdmVyc2lvbiBudW1i
ZXIgMHgwIG9uIGlub2RlIDE4MjUzNjE1NjE1LCByZXNldHRpbmcgdmVyc2lvbiBudW1iZXIKICAg
ICAgICAtIGFnbm8gPSAzNAogICAgICAgIC0gYWdubyA9IDYzCiAgICAgICAgLSBhZ25vID0gMTgK
ICAgICAgICAtIGFnbm8gPSAxOQogICAgICAgIC0gYWdubyA9IDM1CiAgICAgICAgLSBhZ25vID0g
MgogICAgICAgIC0gYWdubyA9IDUwCiAgICAgICAgLSBhZ25vID0gNTEKICAgICAgICAtIGFnbm8g
PSA1MgogICAgICAgIC0gYWdubyA9IDM2CiAgICAgICAgLSBhZ25vID0gMzcKICAgICAgICAtIGFn
bm8gPSAzCiAgICAgICAgLSBhZ25vID0gNTMKICAgICAgICAtIGFnbm8gPSA1NAogICAgICAgIC0g
YWdubyA9IDQKICAgICAgICAtIGFnbm8gPSA1NQogICAgICAgIC0gYWdubyA9IDUKICAgICAgICAt
IGFnbm8gPSAzOAogICAgICAgIC0gYWdubyA9IDM5CiAgICAgICAgLSBhZ25vID0gNDAKICAgICAg
ICAtIGFnbm8gPSA2CiAgICAgICAgLSBhZ25vID0gNwogICAgICAgIC0gYWdubyA9IDQxCiAgICAg
ICAgLSBhZ25vID0gNDIKICAgICAgICAtIGFnbm8gPSA4CiAgICAgICAgLSBhZ25vID0gOQogICAg
ICAgIC0gYWdubyA9IDU2CiAgICAgICAgLSBhZ25vID0gNDMKICAgICAgICAtIGFnbm8gPSAxMAog
ICAgICAgIC0gYWdubyA9IDQ0CiAgICAgICAgLSBhZ25vID0gNTcKICAgICAgICAtIGFnbm8gPSAx
MQogICAgICAgIC0gYWdubyA9IDU4CiAgICAgICAgLSBhZ25vID0gMTIKICAgICAgICAtIGFnbm8g
PSA1OQogICAgICAgIC0gYWdubyA9IDEzCiAgICAgICAgLSBhZ25vID0gMTQKICAgICAgICAtIGFn
bm8gPSAyMAogICAgICAgIC0gYWdubyA9IDIxCiAgICAgICAgLSBhZ25vID0gMjIKICAgICAgICAt
IGFnbm8gPSAyMwogICAgICAgIC0gYWdubyA9IDI0CiAgICAgICAgLSBhZ25vID0gMjUKICAgICAg
ICAtIGFnbm8gPSAyNgogICAgICAgIC0gYWdubyA9IDI3CiAgICAgICAgLSBhZ25vID0gMjgKICAg
ICAgICAtIGFnbm8gPSAyOQogICAgICAgIC0gMTY6MTA6MzY6IHByb2Nlc3Mga25vd24gaW5vZGVz
IGFuZCBpbm9kZSBkaXNjb3ZlcnkgLSAxMTc3NiBvZiAxMTc3NiBpbm9kZXMgZG9uZQogICAgICAg
IC0gcHJvY2VzcyBuZXdseSBkaXNjb3ZlcmVkIGlub2Rlcy4uLgogICAgICAgIC0gMTY6MTA6MzY6
IHByb2Nlc3MgbmV3bHkgZGlzY292ZXJlZCBpbm9kZXMgLSA2NCBvZiA2NCBhbGxvY2F0aW9uIGdy
b3VwcyBkb25lClBoYXNlIDQgLSBjaGVjayBmb3IgZHVwbGljYXRlIGJsb2Nrcy4uLgogICAgICAg
IC0gc2V0dGluZyB1cCBkdXBsaWNhdGUgZXh0ZW50IGxpc3QuLi4KICAgICAgICAtIDE2OjEwOjM3
OiBzZXR0aW5nIHVwIGR1cGxpY2F0ZSBleHRlbnQgbGlzdCAtIDY0IG9mIDY0IGFsbG9jYXRpb24g
Z3JvdXBzIGRvbmUKICAgICAgICAtIGNoZWNrIGZvciBpbm9kZXMgY2xhaW1pbmcgZHVwbGljYXRl
IGJsb2Nrcy4uLgogICAgICAgIC0gYWdubyA9IDAKICAgICAgICAtIGFnbm8gPSAyCiAgICAgICAg
LSBhZ25vID0gMwogICAgICAgIC0gYWdubyA9IDEKICAgICAgICAtIGFnbm8gPSA0CiAgICAgICAg
LSBhZ25vID0gNQogICAgICAgIC0gYWdubyA9IDYKICAgICAgICAtIGFnbm8gPSA3CiAgICAgICAg
LSBhZ25vID0gOAogICAgICAgIC0gYWdubyA9IDkKICAgICAgICAtIGFnbm8gPSAxMAogICAgICAg
IC0gYWdubyA9IDExCiAgICAgICAgLSBhZ25vID0gMTIKICAgICAgICAtIGFnbm8gPSAxMwogICAg
ICAgIC0gYWdubyA9IDE0CiAgICAgICAgLSBhZ25vID0gMTUKICAgICAgICAtIGFnbm8gPSAxNgog
ICAgICAgIC0gYWdubyA9IDE3CiAgICAgICAgLSBhZ25vID0gMTgKICAgICAgICAtIGFnbm8gPSAx
OQogICAgICAgIC0gYWdubyA9IDIwCiAgICAgICAgLSBhZ25vID0gMjEKICAgICAgICAtIGFnbm8g
PSAyMgogICAgICAgIC0gYWdubyA9IDIzCiAgICAgICAgLSBhZ25vID0gMjQKICAgICAgICAtIGFn
bm8gPSAyNQogICAgICAgIC0gYWdubyA9IDI2CiAgICAgICAgLSBhZ25vID0gMjcKICAgICAgICAt
IGFnbm8gPSAyOAogICAgICAgIC0gYWdubyA9IDI5CiAgICAgICAgLSBhZ25vID0gMzAKICAgICAg
ICAtIGFnbm8gPSAzMQogICAgICAgIC0gYWdubyA9IDMyCiAgICAgICAgLSBhZ25vID0gMzMKICAg
ICAgICAtIGFnbm8gPSAzNAogICAgICAgIC0gYWdubyA9IDM1CiAgICAgICAgLSBhZ25vID0gMzYK
ICAgICAgICAtIGFnbm8gPSAzNwogICAgICAgIC0gYWdubyA9IDM4CiAgICAgICAgLSBhZ25vID0g
MzkKICAgICAgICAtIGFnbm8gPSA0MAogICAgICAgIC0gYWdubyA9IDQxCiAgICAgICAgLSBhZ25v
ID0gNDIKICAgICAgICAtIGFnbm8gPSA0MwogICAgICAgIC0gYWdubyA9IDQ0CiAgICAgICAgLSBh
Z25vID0gNDUKICAgICAgICAtIGFnbm8gPSA0NgogICAgICAgIC0gYWdubyA9IDQ3CiAgICAgICAg
LSBhZ25vID0gNDgKICAgICAgICAtIGFnbm8gPSA0OQogICAgICAgIC0gYWdubyA9IDUwCiAgICAg
ICAgLSBhZ25vID0gNTEKICAgICAgICAtIGFnbm8gPSA1MgogICAgICAgIC0gYWdubyA9IDUzCiAg
ICAgICAgLSBhZ25vID0gNTQKICAgICAgICAtIGFnbm8gPSA1NQogICAgICAgIC0gYWdubyA9IDU2
CiAgICAgICAgLSBhZ25vID0gNTcKICAgICAgICAtIGFnbm8gPSA1OAogICAgICAgIC0gYWdubyA9
IDU5CiAgICAgICAgLSBhZ25vID0gNjAKICAgICAgICAtIGFnbm8gPSA2MQogICAgICAgIC0gYWdu
byA9IDYyCiAgICAgICAgLSBhZ25vID0gNjMKICAgICAgICAtIDE2OjEwOjM4OiBjaGVjayBmb3Ig
aW5vZGVzIGNsYWltaW5nIGR1cGxpY2F0ZSBibG9ja3MgLSAxMTc3NiBvZiAxMTc3NiBpbm9kZXMg
ZG9uZQpQaGFzZSA1IC0gcmVidWlsZCBBRyBoZWFkZXJzIGFuZCB0cmVlcy4uLgogICAgICAgIC0g
YWdubyA9IDAKICAgICAgICAtIGFnbm8gPSAxCiAgICAgICAgLSBhZ25vID0gMgogICAgICAgIC0g
YWdubyA9IDMKICAgICAgICAtIGFnbm8gPSA0CiAgICAgICAgLSBhZ25vID0gNQogICAgICAgIC0g
YWdubyA9IDYKICAgICAgICAtIGFnbm8gPSA3CiAgICAgICAgLSBhZ25vID0gOAogICAgICAgIC0g
YWdubyA9IDkKICAgICAgICAtIGFnbm8gPSAxMAogICAgICAgIC0gYWdubyA9IDExCiAgICAgICAg
LSBhZ25vID0gMTIKICAgICAgICAtIGFnbm8gPSAxMwogICAgICAgIC0gYWdubyA9IDE0CiAgICAg
ICAgLSBhZ25vID0gMTUKICAgICAgICAtIGFnbm8gPSAxNgogICAgICAgIC0gYWdubyA9IDE3CiAg
ICAgICAgLSBhZ25vID0gMTgKICAgICAgICAtIGFnbm8gPSAxOQogICAgICAgIC0gYWdubyA9IDIw
CiAgICAgICAgLSBhZ25vID0gMjEKICAgICAgICAtIGFnbm8gPSAyMgogICAgICAgIC0gYWdubyA9
IDIzCiAgICAgICAgLSBhZ25vID0gMjQKICAgICAgICAtIGFnbm8gPSAyNQogICAgICAgIC0gYWdu
byA9IDI2CiAgICAgICAgLSBhZ25vID0gMjcKICAgICAgICAtIGFnbm8gPSAyOAogICAgICAgIC0g
YWdubyA9IDI5CiAgICAgICAgLSBhZ25vID0gMzAKICAgICAgICAtIGFnbm8gPSAzMQogICAgICAg
IC0gYWdubyA9IDMyCiAgICAgICAgLSBhZ25vID0gMzMKICAgICAgICAtIGFnbm8gPSAzNAogICAg
ICAgIC0gYWdubyA9IDM1CiAgICAgICAgLSBhZ25vID0gMzYKICAgICAgICAtIGFnbm8gPSAzNwog
ICAgICAgIC0gYWdubyA9IDM4CiAgICAgICAgLSBhZ25vID0gMzkKICAgICAgICAtIGFnbm8gPSA0
MAogICAgICAgIC0gYWdubyA9IDQxCiAgICAgICAgLSBhZ25vID0gNDIKICAgICAgICAtIGFnbm8g
PSA0MwogICAgICAgIC0gYWdubyA9IDQ0CiAgICAgICAgLSBhZ25vID0gNDUKICAgICAgICAtIGFn
bm8gPSA0NgogICAgICAgIC0gYWdubyA9IDQ3CiAgICAgICAgLSBhZ25vID0gNDgKICAgICAgICAt
IGFnbm8gPSA0OQogICAgICAgIC0gYWdubyA9IDUwCiAgICAgICAgLSBhZ25vID0gNTEKICAgICAg
ICAtIGFnbm8gPSA1MgogICAgICAgIC0gYWdubyA9IDUzCiAgICAgICAgLSBhZ25vID0gNTQKICAg
ICAgICAtIGFnbm8gPSA1NQogICAgICAgIC0gYWdubyA9IDU2CiAgICAgICAgLSBhZ25vID0gNTcK
ICAgICAgICAtIGFnbm8gPSA1OAogICAgICAgIC0gYWdubyA9IDU5CiAgICAgICAgLSBhZ25vID0g
NjAKICAgICAgICAtIGFnbm8gPSA2MQogICAgICAgIC0gYWdubyA9IDYyCiAgICAgICAgLSBhZ25v
ID0gNjMKICAgICAgICAtIDE2OjEwOjM5OiByZWJ1aWxkIEFHIGhlYWRlcnMgYW5kIHRyZWVzIC0g
NjQgb2YgNjQgYWxsb2NhdGlvbiBncm91cHMgZG9uZQogICAgICAgIC0gcmVzZXQgc3VwZXJibG9j
ay4uLgpQaGFzZSA2IC0gY2hlY2sgaW5vZGUgY29ubmVjdGl2aXR5Li4uCiAgICAgICAgLSByZXNl
dHRpbmcgY29udGVudHMgb2YgcmVhbHRpbWUgYml0bWFwIGFuZCBzdW1tYXJ5IGlub2RlcwogICAg
ICAgIC0gdHJhdmVyc2luZyBmaWxlc3lzdGVtIC4uLgogICAgICAgIC0gYWdubyA9IDAKICAgICAg
ICAtIGFnbm8gPSAxCiAgICAgICAgLSBhZ25vID0gMgogICAgICAgIC0gYWdubyA9IDMKICAgICAg
ICAtIGFnbm8gPSA0CiAgICAgICAgLSBhZ25vID0gNQogICAgICAgIC0gYWdubyA9IDYKICAgICAg
ICAtIGFnbm8gPSA3CiAgICAgICAgLSBhZ25vID0gOAogICAgICAgIC0gYWdubyA9IDkKICAgICAg
ICAtIGFnbm8gPSAxMAogICAgICAgIC0gYWdubyA9IDExCiAgICAgICAgLSBhZ25vID0gMTIKICAg
ICAgICAtIGFnbm8gPSAxMwogICAgICAgIC0gYWdubyA9IDE0CiAgICAgICAgLSBhZ25vID0gMTUK
ICAgICAgICAtIGFnbm8gPSAxNgogICAgICAgIC0gYWdubyA9IDE3Ck1ldGFkYXRhIGNvcnJ1cHRp
b24gZGV0ZWN0ZWQgYXQgMHg0MzMwZTMsIHhmc19pbm9kZSBibG9jayAweDE3MzEyYTNmMC8weDIw
MDAKICAgICAgICAtIGFnbm8gPSAxOAogICAgICAgIC0gYWdubyA9IDE5CiAgICAgICAgLSBhZ25v
ID0gMjAKICAgICAgICAtIGFnbm8gPSAyMQogICAgICAgIC0gYWdubyA9IDIyCiAgICAgICAgLSBh
Z25vID0gMjMKICAgICAgICAtIGFnbm8gPSAyNAogICAgICAgIC0gYWdubyA9IDI1CiAgICAgICAg
LSBhZ25vID0gMjYKICAgICAgICAtIGFnbm8gPSAyNwogICAgICAgIC0gYWdubyA9IDI4CiAgICAg
ICAgLSBhZ25vID0gMjkKICAgICAgICAtIGFnbm8gPSAzMAogICAgICAgIC0gYWdubyA9IDMxCiAg
ICAgICAgLSBhZ25vID0gMzIKICAgICAgICAtIGFnbm8gPSAzMwogICAgICAgIC0gYWdubyA9IDM0
CiAgICAgICAgLSBhZ25vID0gMzUKICAgICAgICAtIGFnbm8gPSAzNgogICAgICAgIC0gYWdubyA9
IDM3CiAgICAgICAgLSBhZ25vID0gMzgKICAgICAgICAtIGFnbm8gPSAzOQogICAgICAgIC0gYWdu
byA9IDQwCiAgICAgICAgLSBhZ25vID0gNDEKICAgICAgICAtIGFnbm8gPSA0MgogICAgICAgIC0g
YWdubyA9IDQzCiAgICAgICAgLSBhZ25vID0gNDQKICAgICAgICAtIGFnbm8gPSA0NQogICAgICAg
IC0gYWdubyA9IDQ2CiAgICAgICAgLSBhZ25vID0gNDcKICAgICAgICAtIGFnbm8gPSA0OAogICAg
ICAgIC0gYWdubyA9IDQ5CiAgICAgICAgLSBhZ25vID0gNTAKICAgICAgICAtIGFnbm8gPSA1MQog
ICAgICAgIC0gYWdubyA9IDUyCiAgICAgICAgLSBhZ25vID0gNTMKICAgICAgICAtIGFnbm8gPSA1
NAogICAgICAgIC0gYWdubyA9IDU1CiAgICAgICAgLSBhZ25vID0gNTYKICAgICAgICAtIGFnbm8g
PSA1NwogICAgICAgIC0gYWdubyA9IDU4CiAgICAgICAgLSBhZ25vID0gNTkKICAgICAgICAtIGFn
bm8gPSA2MAogICAgICAgIC0gYWdubyA9IDYxCiAgICAgICAgLSBhZ25vID0gNjIKICAgICAgICAt
IGFnbm8gPSA2MwogICAgICAgIC0gdHJhdmVyc2FsIGZpbmlzaGVkIC4uLgogICAgICAgIC0gbW92
aW5nIGRpc2Nvbm5lY3RlZCBpbm9kZXMgdG8gbG9zdCtmb3VuZCAuLi4KUGhhc2UgNyAtIHZlcmlm
eSBhbmQgY29ycmVjdCBsaW5rIGNvdW50cy4uLgogICAgICAgIC0gMTY6MTA6NDE6IHZlcmlmeSBh
bmQgY29ycmVjdCBsaW5rIGNvdW50cyAtIDY0IG9mIDY0IGFsbG9jYXRpb24gZ3JvdXBzIGRvbmUK
TWV0YWRhdGEgY29ycnVwdGlvbiBkZXRlY3RlZCBhdCAweDQzMzM4NSwgeGZzX2lub2RlIGJsb2Nr
IDB4MTczMTJhM2YwLzB4MjAwMApsaWJ4ZnNfd3JpdGVidWZyOiB3cml0ZSB2ZXJpZmllciBmYWls
ZWQgb24geGZzX2lub2RlIGJubyAweDE3MzEyYTNmMC8weDIwMDAKcmVsZWFzaW5nIGRpcnR5IGJ1
ZmZlciAoYnVsaykgdG8gZnJlZSBsaXN0IQoKICAgICAgICBYRlNfUkVQQUlSIFN1bW1hcnkgICAg
U3VuIEZlYiAgOSAxNjoxMTo1NyAyMDIwCgpQaGFzZQkJU3RhcnQJCUVuZAkJRHVyYXRpb24KUGhh
c2UgMToJMDIvMDkgMTY6MDc6NTYJMDIvMDkgMTY6MDc6NTcJMSBzZWNvbmQKUGhhc2UgMjoJMDIv
MDkgMTY6MDc6NTcJMDIvMDkgMTY6MDg6MDQJNyBzZWNvbmRzClBoYXNlIDM6CTAyLzA5IDE2OjA4
OjA0CTAyLzA5IDE2OjEwOjM2CTIgbWludXRlcywgMzIgc2Vjb25kcwpQaGFzZSA0OgkwMi8wOSAx
NjoxMDozNgkwMi8wOSAxNjoxMDozOAkyIHNlY29uZHMKUGhhc2UgNToJMDIvMDkgMTY6MTA6MzgJ
MDIvMDkgMTY6MTA6MzkJMSBzZWNvbmQKUGhhc2UgNjoJMDIvMDkgMTY6MTA6MzkJMDIvMDkgMTY6
MTA6NDEJMiBzZWNvbmRzClBoYXNlIDc6CTAyLzA5IDE2OjEwOjQxCTAyLzA5IDE2OjEwOjQxCQoK
VG90YWwgcnVuIHRpbWU6IDIgbWludXRlcywgNDUgc2Vjb25kcwpkb25lClJlcGFpciBvZiByZWFk
b25seSBtb3VudCBjb21wbGV0ZS4gIEltbWVkaWF0ZSByZWJvb3QgZW5jb3VyYWdlZC4K

--_002_b2babb761ed24dc986abc3073c5c47fcjoreno_--
