Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CB57DC8E6
	for <lists+linux-xfs@lfdr.de>; Tue, 31 Oct 2023 10:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbjJaJCw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Oct 2023 05:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbjJaJCv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 05:02:51 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6596B3;
        Tue, 31 Oct 2023 02:02:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E8D886732D; Tue, 31 Oct 2023 10:02:42 +0100 (CET)
Date:   Tue, 31 Oct 2023 10:02:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dan.j.williams@intel.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, osandov@fb.com, ruansy.fnst@fujitsu.com
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 22c2699cb068
Message-ID: <20231031090242.GA25889@lst.de>
References: <87fs1s3bk6.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fs1s3bk6.fsf@debian-BULLSEYE-live-builder-AMD64>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Can you also pick up:

"xfs: only remap the written blocks in xfs_reflink_end_cow_extent"

?

Also this seems to a bit of a mix of fixes for 6.7 and big stuff that
is too late for the merge window.

