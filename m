Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4470C35A14E
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Apr 2021 16:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhDIOlR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Apr 2021 10:41:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49110 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhDIOlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:41:16 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUsJi-00069A-Fx; Fri, 09 Apr 2021 14:41:02 +0000
Subject: Re: [PATCH] xfs: fix return of uninitialized value in variable error
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210409141834.667163-1-colin.king@canonical.com>
 <YHBkjihVv4+7D62Q@bfoster>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <08de5ee4-28ca-cb33-7c6c-72f133d97b36@canonical.com>
Date:   Fri, 9 Apr 2021 15:41:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YHBkjihVv4+7D62Q@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09/04/2021 15:28, Brian Foster wrote:
> On Fri, Apr 09, 2021 at 03:18:34PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> A previous commit removed a call to xfs_attr3_leaf_read that
>> assigned an error return code to variable error. We now have
>> a few early error return paths to label 'out' that return
>> error if error is set; however error now is uninitialized
>> so potentially garbage is being returned.  Fix this by setting
>> error to zero to restore the original behaviour where error
>> was zero at the label 'restart'.
>>
>> Addresses-Coverity: ("Uninitialized scalar variable")
>> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  fs/xfs/libxfs/xfs_attr.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 472b3039eabb..902e5f7e6642 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -928,6 +928,7 @@ xfs_attr_node_addname(
>>  	 * Search to see if name already exists, and get back a pointer
>>  	 * to where it should go.
>>  	 */
>> +	error = 0;
>>  	retval = xfs_attr_node_hasname(args, &state);
>>  	if (retval != -ENOATTR && retval != -EEXIST)
>>  		goto out;
> 
> I think it would be nicer to initialize at the top of the function as
> opposed to try and "preserve" historical behavior, but that nit aside:

I did think about that, but this fix does ensure it's zero'd for each
iteration rather than just the once, so it should catch any code changes
later on that may loop back to this point were error is non-zero.

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
>> -- 
>> 2.30.2
>>
> 

