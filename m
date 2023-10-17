Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65C27CC843
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbjJQQBH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 12:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbjJQQBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 12:01:05 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CB7B0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 09:01:04 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2FC5D68C7B; Tue, 17 Oct 2023 18:01:02 +0200 (CEST)
Date:   Tue, 17 Oct 2023 18:01:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/8] xfs: fix units conversion error in
 xfs_bmap_del_extent_delay
Message-ID: <20231017160100.GB20004@lst.de>
References: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs> <169755741293.3165534.2595093205226976244.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755741293.3165534.2595093205226976244.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
