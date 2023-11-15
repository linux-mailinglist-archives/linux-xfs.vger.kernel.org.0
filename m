Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501307DCB2D
	for <lists+linux-xfs@lfdr.de>; Tue, 31 Oct 2023 11:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbjJaKxe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Oct 2023 06:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344003AbjJaKxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 06:53:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF63BB
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 03:53:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12426C433C8;
        Tue, 31 Oct 2023 10:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698749611;
        bh=gxTIuIEVQCXZGKQMzAchM7xFhsen1RbIdvVz+ZT7aqE=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=VuZzEIEhzzRIQELD9FQG9asmlBB3IDjFnbxcEdOt1il6gn/MqAVoYX9eg8VREj2BA
         KmSeMiJI5yTRpBhlApBJjWgDUkwBOStolXhyV/WopXKJmLr7xF939ZkQpW9Mm1aFoh
         FRsQWPbSVlONWs/DOtF3uKl2vW1IBvw3lnaRpYtivl4jA3+qJZnLPsVwVh1NtAH9iy
         zv3sJRhcNQyORUur6PM3Vidiw/auZXxdRcQTEMnjtL3qcZoe+eh/NaMa2ZlsB6epVB
         vVUDFdQaHfGuS8sh0KdOKbr5OCYcX2m53llfTgTxzyA9trxBecQ8fC5WeloB5miWMc
         wyygOGDgOQ5IQ==
References: <87fs1s3bk6.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231031090242.GA25889@lst.de>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dan.j.williams@intel.com, dchinner@redhat.com, djwong@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        osandov@fb.com, ruansy.fnst@fujitsu.com
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 22c2699cb068
Date:   Tue, 31 Oct 2023 16:17:35 +0530
In-reply-to: <20231031090242.GA25889@lst.de>
Message-ID: <87a5rzjc5z.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2023 at 10:02:42 AM +0100, Christoph Hellwig wrote:
> Can you also pick up:
>
> "xfs: only remap the written blocks in xfs_reflink_end_cow_extent"
>
> ?

Sorry, I missed the above patch. I will add it as part of fixes for 6.7-rc1.

>
> Also this seems to a bit of a mix of fixes for 6.7 and big stuff that
> is too late for the merge window.

I ended up doing two rounds of testing since I had to execute the tests the
second time after dropping the "xfs: up(ic_sema) if flushing data device
fails" patch. I hope to send the pull request by end of Wednesday.

-- 
Chandan
