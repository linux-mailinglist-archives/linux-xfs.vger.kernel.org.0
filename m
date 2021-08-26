Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29DA43F8DB3
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Aug 2021 20:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhHZSRL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Aug 2021 14:17:11 -0400
Received: from sandeen.net ([63.231.237.45]:59540 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229733AbhHZSRL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Aug 2021 14:17:11 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D749779F9;
        Thu, 26 Aug 2021 13:16:01 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210826173012.273932-1-bodonnel@redhat.com>
 <20210826180947.GL12640@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: dax: facilitate EXPERIMENTAL warning for dax=inode
 case
Message-ID: <f6ddf52a-0b85-665a-115e-106242b1af95@sandeen.net>
Date:   Thu, 26 Aug 2021 13:16:22 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826180947.GL12640@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 8/26/21 1:09 PM, Darrick J. Wong wrote:
> On Thu, Aug 26, 2021 at 12:30:12PM -0500, Bill O'Donnell wrote:

>> @@ -1584,7 +1586,7 @@ xfs_fs_fill_super(
>>   	if (xfs_has_crc(mp))
>>   		sb->s_flags |= SB_I_VERSION;
>>   
>> -	if (xfs_has_dax_always(mp)) {
>> +	if (xfs_has_dax_always(mp) || xfs_has_dax_inode(mp)) {
> 
> Er... can't this be done without burning another feature bit by:
> 
> 	if (xfs_has_dax_always(mp) || (!xfs_has_dax_always(mp) &&
> 				       !xfs_has_dax_never(mp))) {
> 		...
> 		xfs_warn(mp, "DAX IS EXPERIMENTAL");
> 	}

changing this conditional in this way will also fail dax=inode mounts on
reflink-capable (i.e. default) filesystems, no?

-	if (xfs_has_dax_always(mp)) {
+	if (xfs_has_dax_always(mp) || $NEW_DAX_INODE_TEST) {

...
                 if (xfs_has_reflink(mp)) {
                         xfs_alert(mp,
                 "DAX and reflink cannot be used together!");
                         error = -EINVAL;
                         goto out_filestream_unmount;
                 }
         }

-Eric
