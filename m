Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D467CC8E7
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 18:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjJQQdI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 12:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjJQQdI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 12:33:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252A69E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 09:33:07 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9525F67373; Tue, 17 Oct 2023 18:33:04 +0200 (CEST)
Date:   Tue, 17 Oct 2023 18:33:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/8] xfs: create helpers for rtbitmap block/wordcount
 computations
Message-ID: <20231017163304.GA22722@lst.de>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs> <169755742224.3167663.15974421496522378116.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755742224.3167663.15974421496522378116.stgit@frogsfrogsfrogs>
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
