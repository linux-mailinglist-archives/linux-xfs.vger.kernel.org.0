Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9410D753DFB
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jul 2023 16:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbjGNOqo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jul 2023 10:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjGNOqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:46:44 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97492134
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:46:43 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6236367373; Fri, 14 Jul 2023 16:46:39 +0200 (CEST)
Date:   Fri, 14 Jul 2023 16:46:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        keescook@chromium.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: convert flex-array declarations in struct
 xfs_attrlist*
Message-ID: <20230714144638.GA3628@lst.de>
References: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs> <168934591095.3368057.15849162788748534581.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168934591095.3368057.15849162788748534581.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The change itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But as mentioned in the last thread leaving these out in the UAPI
is a bit dangerous, and at the same time they really shouldn't
be in the uapi.  Do you want me to send an incremental patch for
that?
