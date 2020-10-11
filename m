Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4142128A9B9
	for <lists+linux-xfs@lfdr.de>; Sun, 11 Oct 2020 21:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgJKTiH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 11 Oct 2020 15:38:07 -0400
Received: from relayout04-q02.e.movistar.es ([86.109.101.172]:63441 "EHLO
        relayout04-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgJKTiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Oct 2020 15:38:07 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2020 15:38:06 EDT
Received: from relayout04-redir.e.movistar.es (unknown [86.109.101.204])
        by relayout04-out.e.movistar.es (Postfix) with ESMTP id 4C8X3d6MGGz1yFD
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 21:31:09 +0200 (CEST)
Received: from Telcontar.valinor (103.red-79-158-162.dynamicip.rima-tde.net [79.158.162.103])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout04.e.movistar.es (Postfix) with ESMTPSA id 4C8X3d4VRjz10GV
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 21:31:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 28A193208EB
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 21:31:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at valinor
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id dSUCmHwh1k6j for <linux-xfs@vger.kernel.org>;
        Sun, 11 Oct 2020 21:31:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id EE6083207EB
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 21:31:08 +0200 (CEST)
Date:   Sun, 11 Oct 2020 21:31:08 +0200 (CEST)
From:   "Carlos E. R." <robin.listas@telefonica.net>
X-X-Sender: cer@Telcontar.valinor
To:     Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Feature question
Message-ID: <alpine.LSU.2.23.453.2010112123360.21996@Telcontar.valinor>
User-Agent: Alpine 2.23 (LSU 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-TnetOut-Country: IP: 79.158.162.103 | Country: ES
X-VADETOUT-SPAMSTATE: clean
X-VADETOUT-SPAMSCORE: -100
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout04
X-TnetOut-MsgID: 4C8X3d4VRjz10GV.AA546
X-TnetOut-SpamCheck: no es spam (whitelisted), clean
X-TnetOut-From: robin.listas@telefonica.net
X-TnetOut-Watermark: 1603049469.74996@KKmTjXVDLekfXNiKf+QhRQ
X-Spam-Status: No
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi,

I wonder if there are thoughts about adding compression to XFS?

I am using external disks with encryption (LUKS), btrfs (no snapshots) and 
compression for backup purposes, made with rsync, or dd images. Works 
nicely, but I wonder if there are ideas about having compression with XFS, 
knowing that some developers work on both projects ;-)

ext3/4 mentions compression in the manual, but it never got implemented. 
ntfs has it since long. Yes, they say that hard disk storage is cheap, but 
it is even cheaper with _some_ compression ;-)

- -- 
Cheers
       Carlos E. R, using openSUSE Leap.
-----BEGIN PGP SIGNATURE-----

iHoEARECADoWIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCX4NdfBwccm9iaW4ubGlz
dGFzQHRlbGVmb25pY2EubmV0AAoJELUzGBxtjUfVRusAnRoQghWMnLgo/KY/QASv
fF9bWPElAJ4pPjHAn9GRZ8Wk4VVSHhpf0Zi8qw==
=W2XB
-----END PGP SIGNATURE-----
