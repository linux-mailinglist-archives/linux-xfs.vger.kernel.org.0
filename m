Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1757F7CD395
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Oct 2023 07:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjJRFff (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Oct 2023 01:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjJRFff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 01:35:35 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719DFFE
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 22:35:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8EF4F68AFE; Wed, 18 Oct 2023 07:35:30 +0200 (CEST)
Date:   Wed, 18 Oct 2023 07:35:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: use accessor functions for summary info words
Message-ID: <20231018053530.GA16981@lst.de>
References: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs> <169759504247.3396240.12544584850393209864.stgit@frogsfrogsfrogs> <20231018051934.GF15759@lst.de> <20231018053127.GE3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018053127.GE3195650@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 10:31:27PM -0700, Darrick J. Wong wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Assuming you also meant "Reviewed-by" here too? :)

Yes:

Reviewed-by: Christoph Hellwig <hch@lst.de>
