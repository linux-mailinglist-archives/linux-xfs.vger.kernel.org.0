Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575B57DE469
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Nov 2023 17:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjKAQLe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Nov 2023 12:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjKAQLd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 12:11:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53607FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Nov 2023 09:11:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F179C433C8;
        Wed,  1 Nov 2023 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698855091;
        bh=RoI/kyo3ViZCY8x78VkFgitKFpKFgvvzVEA/6C2H0Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvEnl74t6y41y9XGoWAFrsl4HdCb6NEKhZ4s0k41525yvCdT8oIRwIw5l0hVyBHzx
         vRZswJY0i2t5QTq9sSh8N5UFyIiLDnB4SrwOpvnPonqo3mjauUPwxhQ8MXVtnhB1vk
         K5iFh4mgemoJIZgiAankvL7lq9XPqa7490Fs5DmNHUDWf/K5fRi9DZWxM0JIDeCZXD
         PQxsz81+9/Ce8t5vAKRTrF/qjZRIJHMzNVMh8MjQy/w4BNAJo+LRhgg2IfS/zMbvr8
         hnivMM5N7co6YnoxybZk7z9JZ/OKQmQC01i0WtBxsi78LsFW+58Bq/khDskdB3PxK2
         u07ef6bNGJKiQ==
From:   Christian Brauner <brauner@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shirley Ma <shirley.ma@oracle.com>, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: rotate maintainers
Date:   Wed,  1 Nov 2023 17:11:24 +0100
Message-Id: <20231101-etwas-oboen-73805a23ca0b@brauner>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031234820.GB1205221@frogsfrogsfrogs>
References: <20231031234820.GB1205221@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1331; i=brauner@kernel.org; h=from:subject:message-id; bh=RoI/kyo3ViZCY8x78VkFgitKFpKFgvvzVEA/6C2H0Z4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaQ6VazYbvnJ2b1/ZXRyu92VuAJbxasKehK335tN99TKTjr/ 5vOujlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkc8WJkuBJc2ruo4rLThkdLZpc6Kh xVec1hyHaiNOFFuajAE8/Uv4wMU986NT7Z4qu6rcCcT9vZf/dClt2i5/+/2Jr/wOiFB98pfgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 31 Oct 2023 16:48:20 -0700, Darrick J. Wong wrote:
> Per a discussion last week, let's improve coordination between fs/iomap/
> and the rest of the VFS by shifting Christian into the role of git tree
> maintainer.  I'll stay on as reviewer and main developer, which will
> free up some more time to clean up the code base a bit and help
> filesystem maintainers port off of bufferheads and onto iomap.
> 
> 
> [...]

I assume we'll just have a vfs.iomap branch that we'll merge into
vfs.misc depending on how much work we have. We'll see and we can change
as needed.

--

Applied to the vfs.misc branch of the vfs/vfs.git tree.
Patches in the vfs.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.misc

[1/1] iomap: rotate maintainers
      https://git.kernel.org/vfs/vfs/c/4d75fc6ceba4
