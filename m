Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431E9302F79
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Jan 2021 23:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbhAYWx1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Jan 2021 17:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732708AbhAYWvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 17:51:50 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DF6C061573
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 14:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=V8gcDOrvmtFxdgcNe4LUbf271c5/+i3ADGG3l48B7tA=; b=E5CCnZ2iA/nX7S9GxGQTds1Dvw
        r/dgLZ8wp0PnP8BjCy50I9nVWuW3lV3CU1nDqO+JHa60cjLGt97KjRj9VU6ILraEYkNWu3xiVnIaJ
        iGvZLt/n48PTWsBnKQMEHJS++ipTYpwjy4CMLgv/VPVkDUg2ddptw9fPayJrfF6wi0D/gVsPqRhwq
        FJAK4C6u+dvCUlvbeDXHnJ9u67/4wWQvUISNcvrg+4oWKJ6Dg+MZjKhjwGC979I0O0wrj12hdw847
        A5y2lCFq7Q95X/aV6NenVSUnoucbjqdShG8mPpuR9Zw+yKMrMgzvSf8vh6uWdw/YrZseqLL4ZtPq4
        B64HHhdQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l4AhL-0008Hn-QN; Mon, 25 Jan 2021 22:51:04 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     debian-bugs-closed@lists.debian.org, linux-xfs@vger.kernel.org
Subject: Processed: Close very old bug
Message-ID: <handler.s.C.161161484229960.transcript@bugs.debian.org>
References: <5fad00c8-daf7-af00-6e8e-8054e3ca5087@fishpost.de>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Mon, 25 Jan 2021 22:51:03 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> close 347561
Bug #347561 [xfsprogs] xfsprogs: xfs_growfs should give a more useful error=
 message when filesystem is full
Marked Bug as done
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
347561: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D347561
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
