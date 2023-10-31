Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126B77DD468
	for <lists+linux-xfs@lfdr.de>; Tue, 31 Oct 2023 18:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345230AbjJaRMj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Oct 2023 13:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344282AbjJaRMi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 13:12:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF3983;
        Tue, 31 Oct 2023 10:12:35 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3654A67373; Tue, 31 Oct 2023 18:12:31 +0100 (CET)
Date:   Tue, 31 Oct 2023 18:12:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanbabu@kernel.org>,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dan.j.williams@intel.com, dchinner@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        osandov@fb.com, ruansy.fnst@fujitsu.com
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 22c2699cb068
Message-ID: <20231031171230.GA31580@lst.de>
References: <87fs1s3bk6.fsf@debian-BULLSEYE-live-builder-AMD64> <20231031090242.GA25889@lst.de> <20231031164359.GA1041814@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031164359.GA1041814@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2023 at 09:43:59AM -0700, Darrick J. Wong wrote:
> If by 'big stuff' you mean the MF_MEM_PRE_REMOVE patch, then yes, I
> agree that it's too late to be changing code outside xfs.  Bumping that
> to 6.8 will disappoint Shiyang, regrettably.
> 
> The patchsets for realtime units refactoring and typechecked rt-helpers
> (except for the xfs_rtalloc_args thing) I'd prefer to land in 6.7 for a
> few reasons.  First, the blast radii are contained to the rtalloc
> subsystem of xfs.  Second, I've been testing them for nearly a year now,
> I think they're ready from a QA perspective.

I mean both of them.  And yes, I was hoping to see the RT work in 6.7
as well, but for that it needs to be in linux-next before the release
of 6.6.
