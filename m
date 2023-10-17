Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E4A7CC84E
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 18:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344084AbjJQQE3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 12:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344036AbjJQQE2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 12:04:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB9F95
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 09:04:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1B0E068B05; Tue, 17 Oct 2023 18:04:24 +0200 (CEST)
Date:   Tue, 17 Oct 2023 18:04:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/7] xfs: create helpers to convert rt block numbers to
 rt extent numbers
Message-ID: <20231017160423.GA20304@lst.de>
References: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs> <169755741788.3165781.7214654965503182220.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755741788.3165781.7214654965503182220.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 08:50:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create helpers to do unit conversions of rt block numbers to rt extent
> numbers.  There are two variations -- the suffix "t" denotes the one
> that returns only the truncated extent number; the other one also
> returns the misalignment.  Convert all the div_u64_rem users; we'll do

This need a little update for the new naming scheme.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
