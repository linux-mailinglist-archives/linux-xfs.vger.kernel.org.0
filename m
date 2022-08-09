Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE4B58D85D
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Aug 2022 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242833AbiHILq0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Aug 2022 07:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiHILqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 07:46:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95B0248FE
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 04:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65CFF61028
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 11:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C91E7C4347C
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660045583;
        bh=4HNK/qzcKyPu+Ed2z42rAA+FakKgTbXihb4+MLm2KuE=;
        h=From:To:Subject:Date:From;
        b=f8u6b5WmE+9Zn/U7SeWN1AaL1Ox68id4JLNFuX2HKh1EeifMmNPWkwYWLEVTepqHE
         uvENv0QILAfAViutEzcKVQqsduJfTxrp4y9lILOT6odYLZFEeEsEsK8SYRtH6y9nhB
         vtEX48N7t/DOpcbakkoAIcYfAVgs/LHVJIuezoipRbCoOnI0dkjSDhSMVrbzZHyiyL
         bjUv9AbCoynOLJZtWoDQU/4NGi3e6RAX8rZWlb0NHpy1shBXdOqcKaM9B0ZHN469kj
         LrKfUmvTPIHKpnfQ63a0sKjPuvV86A+7KqopznfbXhvW55jxAluqZJWfdC7HE9Awio
         7ChAH4XkkoSqQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B4D3DC433E4; Tue,  9 Aug 2022 11:46:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216343] New: XFS: no space left in xlog cause system hang
Date:   Tue, 09 Aug 2022 11:46:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhoukete@126.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216343-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216343

            Bug ID: 216343
           Summary: XFS: no space left in xlog cause system hang
           Product: File System
           Version: 2.5
    Kernel Version: 5.10.38
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zhoukete@126.com
        Regression: No

Created attachment 301539
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301539&action=3Dedit
stack

1. cannot login with ssh, system hanged and cannot do anything
2. dmesg report 'audit: audit_backlog=3D41349 > audit_backlog_limit=3D8192'
3. I send sysrq-crash and get vmcore file , I dont know how to reproduce it.

Follwing is my analysis from vmcore:

The reason why tty cannot login is pid 2021571 hold the acct_process mutex,=
 and
2021571 cannot release mutex because it is wait for xlog release space. See=
 the
stac info in the attachment of stack.txt

So I try to figure out what happened to xlog

crash> struct xfs_ail.ail_target_prev,ail_targe,ail_head=C2=A00xffff00ff884=
f1000=20
=C2=A0=C2=A0ail_target_prev =3D 0xe9200058600
=C2=A0=C2=A0ail_target =3D 0xe9200058600
=C2=A0=C2=A0ail_head =3D {
=C2=A0=C2=A0=C2=A0=C2=A0next =3D 0xffff0340999a0a80,=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0prev =3D 0xffff020013c66b40
=C2=A0=C2=A0}

there are 112 log item in ail list
crash> list 0xffff0340999a0a80 | wc -l
112=20

79 item of them are xlog_inode_item
30 item of them are xlog_buf_item

crash> xfs_log_item.li_flags,li_lsn 0xffff0340999a0a80 -x=20
  li_flags =3D 0x1
  li_lsn =3D 0xe910005cc00 =3D=3D=3D> first item lsn

crash> xfs_log_item.li_flags,li_lsn ffff020013c66b40 -x
  li_flags =3D 0x1
  li_lsn =3D 0xe9200058600 =3D=3D=3D> last item lsn

crash>xfs_log_item.li_buf=C2=A00xffff0340999a0a80=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
=C2=A0li_buf =3D 0xffff0200125b7180

crash> xfs_buf.b_flags 0xffff0200125b7180 -x
=C2=A0b_flags =3D 0x110032=C2=A0=C2=A0(XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_IN=
ODES|_XBF_PAGES)=20

crash> xfs_buf.b_state 0xffff0200125b7180 -x
  b_state =3D 0x2 (XFS_BSTATE_IN_FLIGHT)

crash> xfs_buf.b_last_error,b_retries,b_first_retry_time 0xffff0200125b7180=
 -x
  b_last_error =3D 0x0
  b_retries =3D 0x0
  b_first_retry_time =3D 0x0=20

The buf flags show the io had been done(XBF_DONE is set).
When I review the code xfs_buf_ioend, if XBF_DONE is set, xfs_buf_inode_iod=
one
will be called and it will remove the log item from ail list, then release =
the
xlog space by moving the tail_lsn.

But now this item is still in the ail list, and the b_last_error =3D 0, XBF=
_WRITE
is set.

xfs buf log item is the same as the inode log item.

crash> list -s xfs_log_item.li_buf 0xffff0340999a0a80
ffff033f8d7c9de8
=C2=A0=C2=A0li_buf =3D 0x0
crash> xfs_buf_log_item.bli_buf=C2=A0=C2=A0ffff033f8d7c9de8
=C2=A0=C2=A0bli_buf =3D 0xffff0200125b4a80
crash> xfs_buf.b_flags 0xffff0200125b4a80 -x
=C2=A0=C2=A0b_flags =3D 0x100032=C2=A0(XBF_WRITE|XBF_ASYNC|XBF_DONE|_XBF_PA=
GES)=20

I think it is impossible that (XBF_DONE is set & b_last_error =3D 0) and th=
e item
still in the ail.

Is my analysis correct?=20
Why xlog space cannot release space?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
