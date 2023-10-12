Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFD07C65A8
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Oct 2023 08:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbjJLGeM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Oct 2023 02:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347069AbjJLGeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 02:34:12 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177EDBA
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 23:34:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8BE7868AFE; Thu, 12 Oct 2023 08:34:07 +0200 (CEST)
Date:   Thu, 12 Oct 2023 08:34:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 3/7] xfs: create a helper to compute leftovers of
 realtime extents
Message-ID: <20231012063407.GB5326@lst.de>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs> <169704721225.1773611.3934306904978045115.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721225.1773611.3934306904978045115.stgit@frogsfrogsfrogs>
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
