Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BEE7741A1
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Aug 2023 19:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbjHHRZq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Aug 2023 13:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbjHHRZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 13:25:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298EF2026C
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB29D625AE
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DC24C43391
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691506477;
        bh=4yk57UW4WWShz2q/JfAo9efnB6/JFVQyXDfjm2e19EU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OvGVH6ym4ImKvcKMUpewaU1wv0nNB2JIAMy9NFf4jFqG3uQEpvtSWZw3QoopJPyGi
         mggVSrrYzd6r2WqjtISSfbGpuy/Zyrm6hUtmItpCiMP0jNntIuawAKtrq0opBSjxlA
         EnutDnfOsylXnZhh1c+CnlOrvLoQa3UUiF5ggFrWrVBpKg78Wv0D9Ml7dXtk4HW0It
         q6pVAJpgBW9ciQmxvleOtiJw/tPWyaWgeF6Mxa0sBD9xaQdH9NTmQvFPpPZ0O5Y7ic
         Ra+a3GHADFVHTeGbHliVLxI/RDPgTNV+U5wD0JTQqSq+8MZGSoh0NyhqlCTzHVaaW9
         ZaqhGTehxRHwQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4DEB9C53BD2; Tue,  8 Aug 2023 14:54:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217769] XFS crash on mount on kernels >= 6.1
Date:   Tue, 08 Aug 2023 14:54:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xani666@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-217769-201763-LZwwJISnWM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217769-201763@https.bugzilla.kernel.org/>
References: <bug-217769-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217769

--- Comment #9 from Mariusz Gronczewski (xani666@gmail.com) ---
Created attachment 304796
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304796&action=3Dedit
Metadata dump after xfs_repair

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
