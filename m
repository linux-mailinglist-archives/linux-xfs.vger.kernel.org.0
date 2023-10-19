Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A81B7CEEE8
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Oct 2023 07:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjJSFJG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Oct 2023 01:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbjJSFJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 01:09:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1CE137
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 22:09:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D3C3368AFE; Thu, 19 Oct 2023 07:08:57 +0200 (CEST)
Date:   Thu, 19 Oct 2023 07:08:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, osandov@fb.com,
        linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 1/9] xfs: consolidate realtime allocation arguments
Message-ID: <20231019050857.GA14079@lst.de>
References: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs> <169767365557.4127997.9370055131320052124.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169767365557.4127997.9370055131320052124.stgit@frogsfrogsfrogs>
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
