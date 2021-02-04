Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86C7310071
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Feb 2021 00:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBDXDp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Feb 2021 18:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhBDXDp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 18:03:45 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A839C0613D6
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 15:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=ynWC9UFSpn4AXSdkAfb2g0zz05oMJZ4NztAqEc+jnxE=; b=XIf381QOIf+78ruXoyCfZ4Q78P
        gxWZKAhsoKITditRhija4rRwjWHhFYrC3eaF58CHYc052m8KzhPPYgvkaQLIHWnkQvg+BLYk01AAy
        ow1EY1Nmy2RwyFNqri4z3weuzr0kb3RK/wp3ob303EE/ZiQyo7DMe/QLatwWtLAnVfNwZEJwPPGjd
        u5UTbIisFKnGGrrnG0dCcQp/HShdu7R3Vn+kIZEbIC7sB3lvWf53rIDvenG9dMSxGLt+Dv89YIW7f
        VCV8yjlbLpymijAy//suz/hjMEmiWoFBJjUBlCMo1kJMQv/IP3ACUqSWwZ1snCh2eY+X67mKyaDIf
        lNRUDDqg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7neS-0007hv-7f; Thu, 04 Feb 2021 23:03:04 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: confirm
Message-ID: <handler.s.C.161247949427333.transcript@bugs.debian.org>
References: <ab60e4f9-ac58-4398-fcc2-84916b3e61fb@fishpost.de>
X-Debian-PR-Package: src:xfsprogs xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Thu, 04 Feb 2021 23:03:04 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 981662 confirmed
Bug #981662 [src:xfsprogs] xfsprogs-udeb depends on libinih1, not libinih1-=
udeb
Added tag(s) confirmed.
> tags 539723 upstream wontfix
Bug #539723 [xfsprogs] xfsprogs: {mkfs.xfs] Please provide GNU --long optio=
ns
Added tag(s) upstream and wontfix.
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
539723: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D539723
981662: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D981662
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
