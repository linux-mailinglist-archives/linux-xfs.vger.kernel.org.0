Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46087534BFF
	for <lists+linux-xfs@lfdr.de>; Thu, 26 May 2022 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiEZIvP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 May 2022 04:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiEZIvO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 04:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D651027FF0
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 01:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CF8161B30
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F28BC3411A
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653555072;
        bh=BwYLLbtuwIqLdg+kMd2vVVCFoycA/iIDIZtHHHzVv6c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FNrcChT/+y/2by80h3fw7AOkXBShDr6FSZ+TihvVVvnj64wWLRz+aHbb5cwxDjKsV
         Yvdh6hq84gb0vF8epfcoDZqwm11qyAceRrcA1fLWv1y4HYSGy5tHtEbqwgoURTkub5
         FGjnompZsRKh8WDAtAN2KE2ZJ6AMYHNABsYabfhheOb2HjlIyYGPBhzlZkhVuVeZ0f
         8aI6BhqcChF17NZMseZkvO3/zac+ptygrnjiv6wlEyegrcNCuY7E+aR6tJUiERpSdD
         s1kRiH63JIVz7EGkiRZhGTus5Ny2e0yXZLR7nxeIaCQr8A6EKH2xKDkKBKNZT6nKAr
         hA66TXc03foiw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 525FBC05FD2; Thu, 26 May 2022 08:51:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Thu, 26 May 2022 08:51:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mgorman@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-wlHDYlk8AJ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #20 from Mel Gorman (mgorman@suse.de) ---
(In reply to Peter Pavlisko from comment #19)
> (In reply to Mel Gorman from comment #18)
> > Created attachment 301044 [details]
> > Patch to always allocate at least one page
> >=20
> > Hi Peter,
> >=20
> > Could you try the attached patch against 5.18 please? I was unable to
> > reproduce the problem but I think what's happening is that an array for
> > receiving a bulk allocation is partially populated and the bulk allocat=
or
> is
> > returning without allocating at least one page. Allocating even one page
> > should hit the path where kswapd is woken.
>=20
> Hi Mel,
>=20
> I tried this patch and it does indeed work with 5.18.0-rc7. Without the
> patch it freezes, after I apply the patch the archive extracts flawlessly.

Thanks Peter, I'll prepare a proper patch and post it today. You won't be c=
c'd
as I only have the bugzilla email alias for you but I'll post a lore.kernel=
.org
link here.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
