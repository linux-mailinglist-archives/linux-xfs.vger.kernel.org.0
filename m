Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67A77C7CA8
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Oct 2023 06:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjJME05 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Oct 2023 00:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJME04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 00:26:56 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44013C9
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 21:26:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB79A67373; Fri, 13 Oct 2023 06:26:52 +0200 (CEST)
Date:   Fri, 13 Oct 2023 06:26:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCH 5/8] xfs: create helpers for rtbitmap block/wordcount
 computations
Message-ID: <20231013042652.GD5562@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721706.1773834.7063943000548807823.stgit@frogsfrogsfrogs> <20231012054433.GD2795@lst.de> <20231012215546.GN21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012215546.GN21298@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 02:55:46PM -0700, Darrick J. Wong wrote:
> <shrug> The xfsprogs version of this patch uses this helper to decrapify
> the incore rtbitmap computation in xfs_repair:

Ok, let's keep them as-is.

