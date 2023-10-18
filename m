Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892337CE2C2
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Oct 2023 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjJRQ3F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Oct 2023 12:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjJRQ3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 12:29:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E5698
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 09:29:03 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4E4B668AFE; Wed, 18 Oct 2023 18:28:57 +0200 (CEST)
Date:   Wed, 18 Oct 2023 18:28:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: use accessor functions for bitmap words
Message-ID: <20231018162856.GA30150@lst.de>
References: <169759501951.3396240.14113780813650896727.stgit@frogsfrogsfrogs> <169759503104.3396240.5905890094753315092.stgit@frogsfrogsfrogs> <20231018045425.GD15759@lst.de> <20231018162749.GG3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018162749.GG3195650@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:49AM -0700, Darrick J. Wong wrote:
> So I hope you don't mind if I leave it the way it is now. :)

Fine with me, just wanted to throw my two cents in.

